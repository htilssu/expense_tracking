import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/dto/overview_data.dart';
import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:expense_tracking/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class OverviewCard extends StatelessWidget {
  late OverviewData? overviewData;

  OverviewCard({super.key, this.overviewData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng số dư',
                        style: TextStyle(
                            fontSize: TextSize.medium + 1,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoaded) {
                            return Text(
                              CurrencyFormatter.formatCurrency(
                                  state.user.money),
                              style: TextStyle(
                                  fontSize: TextSize.large,
                                  fontWeight: FontWeight.normal,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            );
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!.withAlpha(100),
                            highlightColor: Colors.grey[200]!.withAlpha(120),
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 130,
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.grey[300],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_downward,
                          size: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Thu nhập',
                      style: TextStyle(
                          fontSize: TextSize.medium,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
                Row(
                  spacing: 4,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_upward,
                          size: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Chi tiêu',
                      style: TextStyle(
                          fontSize: TextSize.medium,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (overviewData != null) ...[
                  Text(
                    CurrencyFormatter.formatCurrency(overviewData!.totalIncome),
                    style: TextStyle(
                        fontSize: TextSize.medium + 2,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text(
                    CurrencyFormatter.formatCurrency(
                        overviewData!.totalExpense),
                    style: TextStyle(
                        fontSize: TextSize.medium + 2,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onPrimary),
                  )
                ] else ...[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!.withAlpha(100),
                    highlightColor: Colors.grey[200]!.withAlpha(120),
                    child: Container(
                      width: 80,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!.withAlpha(100),
                    highlightColor: Colors.grey[200]!.withAlpha(120),
                    child: Container(
                      width: 80,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
