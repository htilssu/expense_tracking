import 'package:expense_tracking/application/service/analysis_service_impl.dart';
import 'package:expense_tracking/application/service/transaction_service_impl.dart';
import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/dto/overview_data.dart';
import 'package:expense_tracking/domain/service/analysis_service.dart';
import 'package:expense_tracking/domain/service/transaction_service.dart';
import 'package:expense_tracking/infrastructure/repository/transaction_repostory_impl.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/presentation/features/overview/widget/et_home_appbar.dart';
import 'package:expense_tracking/presentation/features/overview/widget/overview_card.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/transaction_history_screen.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/transaction_item_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../domain/entity/transaction.dart';
import '../../transaction/screen/create_transaction_screen.dart';
import '../../transaction/widget/transaction_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(
      {super.key,
      TransactionService? transactionService,
      AnalysisService? analysisService}) {
    this.transactionService = transactionService ??
        TransactionServiceImpl(TransactionRepositoryImpl());
    this.analysisService = analysisService ?? AnalysisServiceImpl();
  }

  late TransactionService transactionService;
  late AnalysisService analysisService;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Transaction>> _transactionsFuture;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _transactionsFuture =
        widget.transactionService.getRecentTransactionsByUserId();
  }

  Future<void> _refreshTransactions() async {
    setState(() {
      _transactionsFuture =
          widget.transactionService.getRecentTransactionsByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        SizedBox(
          height: 320,
          child: Stack(
            children: [
              const EtHomeAppbar(),
              Positioned(
                  top: 280 - 40 - 150 / 2,
                  left: 0,
                  child: Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: FutureBuilder<OverviewData>(
                        future: widget.analysisService.getOverviewData(),
                        builder: (context, snapshot) {
                          return OverviewCard(
                            overviewData: snapshot.data,
                          );
                        },
                      )))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch sử',
                style: TextStyle(
                    fontSize: TextSize.medium, fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TransactionHistoryScreen(),
                        ));
                  },
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    overlayColor: Colors.transparent,
                  ),
                  child: const Text(
                    textAlign: TextAlign.end,
                    'Xem tất cả',
                    style: TextStyle(
                      fontSize: TextSize.small + 3,
                    ),
                  ))
            ],
          ),
        ),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            return FutureBuilder<List<Transaction>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data!.isNotEmpty &&
                    state is CategoryLoaded) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SmartRefresher(
                        enablePullDown: true,
                        onRefresh: _onRefresh,
                        header: WaterDropMaterialHeader(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        controller: _refreshController,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            for (Transaction transaction in snapshot.data!)
                              TransactionItem(transaction),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    state is CategoryLoading) {
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        for (int i = 0; i < 5; i++)
                          const TransactionItemSkeleton()
                      ],
                    ),
                  ));
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SmartRefresher(
                      enablePullDown: true,
                      onRefresh: _onRefresh,
                      header: WaterDropMaterialHeader(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      controller: _refreshController,
                      child: Column(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Không có giao dịch nào',
                            style: TextStyle(fontSize: TextSize.medium),
                          ),
                          IconButton(
                              color: AppTheme.placeholderColor,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
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
                          const Text(
                            'Thêm giao dịch',
                            style: TextStyle(fontSize: TextSize.medium),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }

  void _onRefresh() async {
    await _refreshTransactions();
    _refreshController.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;
}
