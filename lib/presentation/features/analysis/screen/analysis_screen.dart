import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracking/application/service/transaction_service_impl.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/entity/transaction.dart'
    as app_transaction;
import 'package:expense_tracking/domain/service/transaction_service.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../utils/currency_formatter.dart';

// Class hỗ trợ lưu trữ danh mục và tổng tiền giao dịch
class CategoryWithTransactions {
  final Category category;
  int totalAmount;

  CategoryWithTransactions(this.category, this.totalAmount);
}

// Class lưu trữ cache cho dữ liệu tháng
class MonthlyDataCache {
  final int month;
  final int year;
  final List<CategoryWithTransactions> expenseCategories;
  final List<CategoryWithTransactions> incomeCategories;
  final int totalExpense;
  final int totalIncome;
  final DateTime timestamp;

  MonthlyDataCache({
    required this.month,
    required this.year,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.totalExpense,
    required this.totalIncome,
    required this.timestamp,
  });

  // Kiểm tra xem cache còn hợp lệ không (trong vòng 5 phút)
  bool get isValid {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inMinutes < 5; // Cache có hiệu lực trong 5 phút
  }
}

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late int _selectedSegment;
  int touchedIndex = -1;

  // Biến lưu tháng năm hiện tại
  DateTime _currentDate = DateTime.now();

  // Map lưu trữ cache theo tháng năm (key: "month-year")
  final Map<String, MonthlyDataCache> _cacheData = {};

  // Danh sách màu cho biểu đồ
  final List<Color> chartColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
  ];

  // Khai báo transaction service
  final TransactionService _transactionService = TransactionServiceImpl();

  // Biến để lưu trữ dữ liệu phân tích
  List<CategoryWithTransactions> _expenseCategories = [];
  List<CategoryWithTransactions> _incomeCategories = [];
  int _totalExpense = 0;
  int _totalIncome = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedSegment = 0;

    // Load categories when screen initializes
    _loadCategoriesForMonth();
  }

  // Tạo key cho cache từ tháng và năm
  String _getCacheKey(DateTime date) {
    return '${date.month}-${date.year}';
  }

  // Hàm tải danh mục cho tháng được chọn
  void _loadCategoriesForMonth() async {
    // Kiểm tra cache
    final cacheKey = _getCacheKey(_currentDate);
    final cachedData = _cacheData[cacheKey];

    // Nếu có cache và còn hiệu lực, sử dụng cache
    if (cachedData != null && cachedData.isValid) {
      setState(() {
        _expenseCategories = cachedData.expenseCategories;
        _incomeCategories = cachedData.incomeCategories;
        _totalExpense = cachedData.totalExpense;
        _totalIncome = cachedData.totalIncome;
        _isLoading = false;
      });
      return;
    }

    // Nếu không có cache hoặc hết hiệu lực, tải dữ liệu mới
    setState(() {
      _isLoading = true;
    });

    try {
      // Lấy danh sách danh mục
      var categoryState = BlocProvider.of<CategoryBloc>(context).state;
      List<Category> categories = [];

      if (categoryState is CategoryLoaded) {
        categories = [...categoryState.categories];
      }

      // Chờ danh mục được tải nếu chưa sẵn sàng
      if (categories.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
        categoryState = BlocProvider.of<CategoryBloc>(context).state;
        categories = categoryState.categories;
      }

      // Tách danh mục thành chi tiêu và thu nhập
      var expenseCategories =
          categories.where((c) => c.type == 'expense').toList();
      var incomeCategories =
          categories.where((c) => c.type == 'income').toList();

      // Chuẩn bị danh sách ID danh mục
      List<String> expenseCategoryIds =
          expenseCategories.map((e) => e.id).toList();
      List<String> incomeCategoryIds =
          incomeCategories.map((e) => e.id).toList();

      // Lấy dữ liệu giao dịch theo tháng và loại danh mục
      List<app_transaction.Transaction> expenseTransactions =
          await _transactionService.getTransactionsByMonthAndCategoryType(
              _currentDate, expenseCategoryIds);

      List<app_transaction.Transaction> incomeTransactions =
          await _transactionService.getTransactionsByMonthAndCategoryType(
              _currentDate, incomeCategoryIds);

      // Tạo map để tính tổng số tiền cho từng danh mục
      Map<String, int> expenseTotals = {};
      Map<String, int> incomeTotals = {};

      // Tính tổng chi tiêu cho từng danh mục
      for (var transaction in expenseTransactions) {
        expenseTotals[transaction.category] =
            (expenseTotals[transaction.category] ?? 0) + transaction.value;
      }

      // Tính tổng thu nhập cho từng danh mục
      for (var transaction in incomeTransactions) {
        incomeTotals[transaction.category] =
            (incomeTotals[transaction.category] ?? 0) + transaction.value;
      }

      // Tạo danh sách CategoryWithTransactions cho từng loại
      List<CategoryWithTransactions> expenseCategoriesWithTransactions = [];
      List<CategoryWithTransactions> incomeCategoriesWithTransactions = [];

      // Tổng số tiền
      int totalExpense = 0;
      int totalIncome = 0;

      // Gán tổng số tiền cho từng danh mục chi tiêu
      for (var category in expenseCategories) {
        int amount = expenseTotals[category.id] ?? 0;
        expenseCategoriesWithTransactions
            .add(CategoryWithTransactions(category, amount));
        totalExpense += amount;
      }

      // Gán tổng số tiền cho từng danh mục thu nhập
      for (var category in incomeCategories) {
        int amount = incomeTotals[category.id] ?? 0;
        incomeCategoriesWithTransactions
            .add(CategoryWithTransactions(category, amount));
        totalIncome += amount;
      }

      // Sắp xếp danh mục theo tổng số tiền
      expenseCategoriesWithTransactions
          .sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
      incomeCategoriesWithTransactions
          .sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

      // Lưu vào cache
      _cacheData[cacheKey] = MonthlyDataCache(
        month: _currentDate.month,
        year: _currentDate.year,
        expenseCategories: expenseCategoriesWithTransactions,
        incomeCategories: incomeCategoriesWithTransactions,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
        timestamp: DateTime.now(),
      );

      // Cập nhật state
      setState(() {
        _expenseCategories = expenseCategoriesWithTransactions;
        _incomeCategories = incomeCategoriesWithTransactions;
        _totalExpense = totalExpense;
        _totalIncome = totalIncome;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Lỗi khi tải dữ liệu: $e');
    }
  }

  // Xóa cache cho tháng hiện tại - có thể gọi khi cần làm mới dữ liệu
  void _invalidateCurrentCache() {
    final cacheKey = _getCacheKey(_currentDate);
    _cacheData.remove(cacheKey);
  }

  // Làm mới dữ liệu (có thể gọi từ nút pull-to-refresh hoặc nút làm mới)
  void _refreshData() {
    _invalidateCurrentCache();
    _loadCategoriesForMonth();
  }

  // Hàm chuyển tháng trước
  void _prevMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
      _loadCategoriesForMonth();
    });
  }

  // Hàm chuyển tháng sau
  void _nextMonth() {
    // Kiểm tra tháng hiện tại
    DateTime now = DateTime.now();
    DateTime nextMonth = DateTime(_currentDate.year, _currentDate.month + 1, 1);

    // Chỉ cho phép chuyển đến tháng tiếp theo nếu không lớn hơn tháng hiện tại
    if (nextMonth.year < now.year ||
        (nextMonth.year == now.year && nextMonth.month <= now.month)) {
      setState(() {
        _currentDate = nextMonth;
        _loadCategoriesForMonth();
      });
    }
  }

  // Format tháng năm
  String _getMonthYearString() {
    List<String> months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12'
    ];
    return '${months[_currentDate.month - 1]} ${_currentDate.year}';
  }

  // Hiển thị bảng chọn tháng và năm
  Future<void> _showMonthYearPicker() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(now.year - 5, 1),
      lastDate: now,
      locale: const Locale('vi', 'VN'),
    );

    if (picked != null && picked != _currentDate) {
      setState(() {
        _currentDate = picked;
        _loadCategoriesForMonth();
      });
    }
  }

  List<PieChartSectionData> showingSections(
      List<CategoryWithTransactions> categories, double total) {
    return List.generate(categories.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 40.0 : 35.0;
      final category = categories[i];
      final percentage = total > 0 ? (category.totalAmount / total) * 100 : 0.0;

      // Sử dụng màu từ danh mục nếu có, nếu không sử dụng màu mặc định từ danh mục
      final color = category.category.color ?? category.category.defaultColor;

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend(List<CategoryWithTransactions> categories, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final percentage =
            total > 0 ? (category.totalAmount / total) * 100 : 0.0;

        // Kiểm tra xem mục này có đang được hover không
        final isHovered = index == touchedIndex;

        // Sử dụng màu từ danh mục nếu có, nếu không sử dụng màu mặc định
        final color = category.category.color ?? category.category.defaultColor;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
              vertical: 4.0, horizontal: isHovered ? 8.0 : 0.0),
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          decoration: BoxDecoration(
            color: isHovered ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: isHovered ? 16 : 12,
                height: isHovered ? 16 : 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.category.name,
                  style: TextStyle(
                    fontSize: isHovered ? 13 : 12,
                    fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: isHovered ? 13 : 12,
                  fontWeight: FontWeight.bold,
                  color: isHovered ? color : Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                CurrencyFormatter.formatCurrency(category.totalAmount),
                style: TextStyle(
                  fontSize: isHovered ? 13 : 12,
                  color: Colors.grey,
                  fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart(
      List<CategoryWithTransactions> categories, double total, String title) {
    var top5Categories =
        categories.take(5).where((cat) => cat.totalAmount > 0).toList();

    if (top5Categories.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                startDegreeOffset: 270,
                centerSpaceRadius: 70,
                sections: showingSections(top5Categories, total),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(top5Categories, total),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.expenseManagement,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _refreshData,
            tooltip: l10n.refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần điều khiển tháng - luôn hiển thị
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _prevMonth,
                    ),
                    GestureDetector(
                      onTap: _showMonthYearPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getMonthYearString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.calendar_today_outlined, size: 16),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tabs - luôn hiển thị
              CustomSlidingSegmentedControl(
                isStretch: true,
                initialValue: 0,
                children: {
                  0: Text(
                    l10n.expense,
                    style: TextStyle(
                      color:
                          _selectedSegment == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  1: Text(
                    l10n.income,
                    style: TextStyle(
                      color:
                          _selectedSegment == 1 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                },
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                thumbDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInToLinear,
                onValueChanged: (value) {
                  setState(() {
                    _selectedSegment = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Hiển thị skeleton loading hoặc dữ liệu dựa trên trạng thái loading
              _isLoading
                  ? _buildSkeletonLoading()
                  : Column(
                      children: [
                        // Hiển thị biểu đồ theo tab được chọn
                        if (_selectedSegment == 0)
                          _buildChart(_expenseCategories,
                              _totalExpense.toDouble(), l10n.top5Expense)
                        else
                          _buildChart(_incomeCategories,
                              _totalIncome.toDouble(), l10n.top5Income),
                        const SizedBox(height: 16),

                        // Hiển thị danh sách theo tab được chọn
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _selectedSegment == 0
                              ? _expenseCategories.length
                              : _incomeCategories.length,
                          itemBuilder: (context, index) {
                            var category = _selectedSegment == 0
                                ? _expenseCategories[index]
                                : _incomeCategories[index];
                            var total = _selectedSegment == 0
                                ? _totalExpense
                                : _totalIncome;
                            var percentage = total > 0
                                ? (category.totalAmount / total) * 100
                                : 0.0;
                            // Sử dụng màu từ danh mục hoặc màu mặc định
                            var iconColor = category.category.color ??
                                category.category.defaultColor;
                            return _buildExpenseItem(
                              category.category.name,
                              category.totalAmount,
                              percentage,
                              iconColor,
                              category.category.iconData,
                            );
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget skeleton loading
  Widget _buildSkeletonLoading() {
    return Column(
      children: [
        // Skeleton cho biểu đồ
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skeleton cho tiêu đề biểu đồ
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 120,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Skeleton cho biểu đồ tròn
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: AspectRatio(
                  aspectRatio: 1.8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Skeleton cho chú thích
              Column(
                children: List.generate(
                    5,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 40,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 60,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Skeleton cho danh sách các mục
        Column(
          children: List.generate(
              5,
              (index) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: double.infinity,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 50,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: const Icon(
                            Icons.chevron_right,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  )),
        ),
      ],
    );
  }

  Widget _buildExpenseItem(
    String title,
    int amount,
    double percentage,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.formatCurrency(amount),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
