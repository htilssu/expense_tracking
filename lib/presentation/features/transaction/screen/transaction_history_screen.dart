import 'package:expense_tracking/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/transaction_item.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/transaction_item_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/text_constant.dart';
import '../../../../domain/entity/transaction.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  Future<bool?> _showOptionsDialog(
      BuildContext context, Transaction transaction) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tùy chọn'),
        content: const Text('Bạn muốn làm gì với giao dịch này?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Hủy bỏ
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Chỉnh sửa'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Xác nhận xóa
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
      if (state is TransactionLoaded) {
        if (state.transactions.isEmpty) {
          return _getNoTransactionWidget();
        }
      }

      return Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: false,
              pinned: false,
              title: Text('Lịch sử giao dịch'),
              centerTitle: true,
            ),
            if (state is TransactionLoaded)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final transaction = state.transactions[index];
                      return Dismissible(
                        key: Key(transaction.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.edit, color: Colors.white),
                              SizedBox(width: 20),
                              Icon(Icons.delete, color: Colors.white),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã xóa giao dịch')),
                          );
                        },
                        confirmDismiss: (direction) async {
                          return await _showOptionsDialog(context, transaction);
                        },
                        child: TransactionItem(transaction),
                      );
                    },
                    childCount: state.transactions.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return const TransactionItemSkeleton();
                    },
                    childCount: 10,
                  ),
                ),
              )
          ],
        ),
      );
    });
  }

  Widget _getNoTransactionWidget() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Lịch sử giao dịch'),
        ),
        body: const Center(
          child: Text(
            'Không có giao dịch nào',
            style: TextStyle(fontSize: TextSize.medium),
          ),
        ));
  }
}
