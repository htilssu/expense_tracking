import 'package:expense_tracking/constants/app_theme.dart';
import 'package:expense_tracking/constants/text_constant.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {

            Category? category;
            if (state is CategoryLoaded) {
              category = state.categories
                  .firstWhere((element) => element.id == _transaction.category);
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SizedBox(width: 8),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state is CategoryLoaded)
                      Text(
                        category!.name,
                        style: TextStyle(
                            fontSize: TextSize.medium,
                            fontWeight: FontWeight.bold),
                      )
                    else
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    Text(
                      _transaction.note,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: TextSize.medium,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.hintColor.withAlpha(120)),
                    )
                  ],
                )),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${category!.type == "income" ? "+" : "-"} ${CurrencyFormatter.formatCurrency(_transaction.value)}",
                      style: TextStyle(
                        fontSize: TextSize.medium + 4,
                        color: category.type == "income"
                            ? Colors.green
                            : Colors.red[300],
                      ),
                    ),
                    Text(
                      Date.format(_transaction.createdAt),
                      style:
                          TextStyle(color: AppTheme.hintColor.withAlpha(120)),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
