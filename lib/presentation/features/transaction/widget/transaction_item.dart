import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/presentation/bloc/category_bloc.dart';
import 'package:expense_tracking/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/transaction.dart';
import '../../../../utils/date_format.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(this._transaction, {super.key});

  final Transaction _transaction;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.placeholderColor.withAlpha(20),
                  ),
                  child: Center(
                    child: Text(
                      //TODO: get category icon
                      "😊",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: TextSize.large),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoaded) {
                          return Text(
                            state.categories
                                .firstWhere((element) =>
                                    element.id == _transaction.category)
                                .name,
                            style: TextStyle(
                                fontSize: TextSize.medium,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text("Loading...");
                        }
                      },
                    ),
                    Text(
                      _transaction.note,
                      style: TextStyle(
                          fontSize: TextSize.medium,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.hintColor.withAlpha(120)),
                    ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.formatCurrency(_transaction.value),
                  style: TextStyle(
                    fontSize: TextSize.medium + 4,
                  ),
                ),
                Text(
                  Date.format(_transaction.createdAt),
                  style: TextStyle(color: AppTheme.hintColor.withAlpha(120)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
