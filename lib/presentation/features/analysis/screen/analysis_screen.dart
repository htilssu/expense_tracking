import 'package:expense_tracking/application/service/transaction_service_impl.dart';
import 'package:expense_tracking/domain/service/transaction_service.dart';
import 'package:expense_tracking/infrastructure/repository/transaction_repostory_impl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entity/transaction.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late TransactionService _transactionService;
  late Future<List<Transaction>> _transactionsFuture;
  int _selectedPeriod = 0; // 0: Tháng, 1: Tuần, 2: Năm

  @override
  void initState() {
    super.initState();
    _transactionService = TransactionServiceImpl(TransactionRepositoryImpl());
    _transactionsFuture = _transactionService.getRecentTransactionsByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCard(),
                  const SizedBox(height: 16),
                  _buildPeriodSelector(),
                  const SizedBox(height: 16),
                  _buildPieChart(),
                  const SizedBox(height: 16),
                  _buildLineChart(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Transaction>>(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Không có dữ liệu giao dịch');
            }

            final transactions = snapshot.data!;
            final totalIncome = 10.0;
            final totalExpense = 900.0;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOverviewItem('Thu nhập', totalIncome, Colors.green),
                _buildOverviewItem('Chi tiêu', totalExpense, Colors.red),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '${value.toStringAsFixed(0)} VNĐ',
          style: TextStyle(fontSize: 18, color: color),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment<int>(value: 0, label: Text('Tháng')),
        ButtonSegment<int>(value: 1, label: Text('Tuần')),
        ButtonSegment<int>(value: 2, label: Text('Năm')),
      ],
      selected: {_selectedPeriod},
      onSelectionChanged: (newSelection) {
        setState(() {
          _selectedPeriod = newSelection.first;
          // TODO: Cập nhật dữ liệu theo khoảng thời gian nếu cần
        });
      },
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có dữ liệu để phân tích'));
          }

          final transactions = snapshot.data!;
          final expenseByCategory = <String, double>{};

          return PieChart(
            PieChartData(
              sections: expenseByCategory.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value,
                  title:
                      '${entry.key}\n${(entry.value / expenseByCategory.values.reduce((a, b) => a + b) * 100).toStringAsFixed(1)}%',
                  color: _getRandomColor(),
                  radius: 80,
                  titleStyle:
                      const TextStyle(fontSize: 12, color: Colors.white),
                );
              }).toList(),
              centerSpaceRadius: 40,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 200,
      child: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có dữ liệu xu hướng'));
          }

          final transactions = snapshot.data!;
          final expenseByDay = <String, double>{};

          final sortedDays = expenseByDay.keys.toList()..sort();
          return LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: sortedDays
                      .map((day) => FlSpot(sortedDays.indexOf(day).toDouble(),
                          expenseByDay[day]!))
                      .toList(),
                  isCurved: true,
                  color: Colors.red,
                  dotData: FlDotData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final dayIndex = value.toInt();
                      if (dayIndex >= 0 && dayIndex < sortedDays.length) {
                        return Text(
                            sortedDays[dayIndex].substring(5)); // Hiển thị ngày
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
              ),
              borderData: FlBorderData(show: true),
            ),
          );
        },
      ),
    );
  }

  Color _getRandomColor() {
    return Colors
        .primaries[DateTime.now().microsecond % Colors.primaries.length];
  }
}
