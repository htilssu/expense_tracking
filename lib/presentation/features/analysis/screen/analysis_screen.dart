import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_theme.dart';
import '../../../../constants/text_constant.dart';
import '../../../../utils/currency_formatter.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late int _selectedSegment;

  @override
  void initState() {
    super.initState();
    _selectedSegment = 0;
  }

  @override
  Widget build(BuildContext context) {
    var user = (BlocProvider.of<UserBloc>(context).state as UserLoaded).user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Balance và Total Expense
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_wallet,
                              color: Colors.green),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Số dư',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(CurrencyFormatter.formatCurrency(user.money),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_down, color: Colors.blue),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Đã chi tiêu',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(CurrencyFormatter.formatCurrency(user.money),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress Bar và Text
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: 0.3,
                        backgroundColor: Colors.grey[300],
                        color: Colors.green,
                        minHeight: 10,
                      ),
                      const SizedBox(height: 8),
                      const Text('30% Of Your Expenses, Looks Good.',
                          style: TextStyle(fontSize: 14, color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Tabs (Daily, Weekly, Monthly, Year)
                CustomSlidingSegmentedControl(
                  isStretch: true,
                  onValueChanged: (int value) {
                    setState(() {
                      _selectedSegment = value;
                    });
                  },
                  curve: Curves.easeInCubic,
                  innerPadding: const EdgeInsets.all(4),
                  thumbDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4)),
                  decoration: BoxDecoration(
                      color: AppTheme.placeholderColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(7)),
                  children: {
                    0: AnimatedDefaultTextStyle(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        'Hàng tuần',
                        style: TextStyle(
                            fontSize: TextSize.medium,
                            color: _selectedSegment == 0
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    1: AnimatedDefaultTextStyle(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        'Hàng tháng',
                        style: TextStyle(
                            fontSize: TextSize.medium,
                            color: _selectedSegment == 1
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    2: AnimatedDefaultTextStyle(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        'Hàng năm',
                        style: TextStyle(
                            fontSize: TextSize.medium,
                            color: _selectedSegment == 2
                                ? Colors.white
                                : Colors.black),
                      ),
                    )
                  },
                ),
                const SizedBox(height: 16),
                // Biểu đồ Income & Expenses
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Income & Expenses',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Icons.question_mark, color: Colors.grey),
                              Icon(Icons.calendar_today, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Placeholder cho biểu đồ (sử dụng Container đơn giản, bạn có thể thay bằng fl_chart)
                      SizedBox(
                        height: 200,
                        child: CustomPaint(
                          painter: BarChartPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Income và Expense Targets
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.green),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Income',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text('\$4,120.00',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.blue),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Expense',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text('\$1,187.40',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Bottom Navigation Bar
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}

// Class đơn giản để vẽ biểu đồ cột (placeholder)
class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGreen = Paint()..color = Colors.green;
    final paintBlue = Paint()..color = Colors.blue;

    // Dữ liệu giả lập (chiều cao các cột)
    final heights = [20, 50, 30, 80, 10, 40, 20]; // Thay đổi theo nhu cầu
    final barWidth = size.width / 7 - 10;
    double x = 0;

    for (int i = 0; i < heights.length; i++) {
      double barHeight = heights[i] / 100 * size.height;
      // Vẽ cột xanh lá (income)
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
        paintGreen,
      );
      // Vẽ cột xanh dương (expense) chồng lên (giả lập)
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - barHeight / 2, barWidth, barHeight / 2),
        paintBlue,
      );
      x += barWidth + 10; // Khoảng cách giữa các cột
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
