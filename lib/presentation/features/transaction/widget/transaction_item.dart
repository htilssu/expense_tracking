import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:flutter/material.dart';

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
                    Text(
                      // TODO: get category name
                      "Ăn sáng",
                      style: TextStyle(
                        fontSize: TextSize.medium + 2,
                      ),
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
                  "100000",
                  style: TextStyle(
                    fontSize: TextSize.large,
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
