import 'package:expense_tracking/application/service/transaction_service_impl.dart';
import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/service/transaction_service.dart';
import 'package:expense_tracking/presentation/common_widgets/et_navigation_bar.dart';
import 'package:expense_tracking/presentation/features/overview/widget/et_home_appbar.dart';
import 'package:expense_tracking/presentation/features/overview/widget/overview_card.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/transaction_item_skeleton.dart';
import 'package:flutter/material.dart';

import '../../../../application/service/category_service_impl.dart';
import '../../../../domain/entity/transaction.dart';
import '../../../../domain/service/category_service.dart';
import '../../transaction/screen/create_transaction_screen.dart';
import '../../transaction/widget/transaction_item.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TransactionService transactionService = TransactionServiceImpl();
  final CategoryService categoryService = CategoryServiceImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: EtNavigationBar(),
      body: Column(
        children: [
          SizedBox(
            height: 370,
            child: Stack(
              children: [
                EtHomeAppbar(),
                Positioned(
                    top: 180,
                    left: 0,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        child: OverviewCard()))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lịch sử",
                  style: TextStyle(
                      fontSize: TextSize.medium, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      overlayColor: Colors.transparent,
                      padding: EdgeInsets.all(8),
                    ),
                    child: Text(
                      "Xem tất cả",
                      style: TextStyle(
                        fontSize: TextSize.small + 3,
                      ),
                    ))
              ],
            ),
          ),
          FutureBuilder(
            future: transactionService.getRecentTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    children: [
                      for (int i = 0; i < 5; i++) TransactionItemSkeleton()
                    ],
                  ),
                ));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Không có giao dịch nào",
                          style: TextStyle(fontSize: TextSize.medium),
                        ),
                        IconButton(
                            color: AppTheme.placeholderColor,
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  AppTheme.placeholderColor.withAlpha(20)),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CreateTransactionScreen();
                                },
                              ));
                            },
                            icon: Icon(
                              Icons.add,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        Text(
                          "Thêm giao dịch",
                          style: TextStyle(fontSize: TextSize.medium),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    children: [
                      for (Transaction transaction in snapshot.data!)
                        TransactionItem(transaction),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
