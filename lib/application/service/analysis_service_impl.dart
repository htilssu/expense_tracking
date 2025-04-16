import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking/domain/dto/overview_data.dart';
import 'package:expense_tracking/domain/repository/category_repository.dart';
import 'package:expense_tracking/domain/service/analysis_service.dart';
import 'package:flutter/foundation.dart';

import '../../infrastructure/repository/category_repository_impl.dart';
import '../../utils/auth.dart';
import '../../utils/logging.dart';

class AnalysisServiceImpl extends AnalysisService {
  CategoryRepository? categoryRepository;
  late CollectionReference<Map<String, dynamic>> refTransaction =
      FirebaseFirestore.instance.collection('transactions');

  AnalysisServiceImpl({this.categoryRepository}) {
    categoryRepository ??= CategoryRepositoryImpl();
  }

  @override
  Future<OverviewData> getOverviewData() async {
    var user = Auth.uid();
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    var categories = await categoryRepository!.getCategories();
    AggregateQuerySnapshot incomeAgg;
    AggregateQuerySnapshot expenseAgg;
    try {
      incomeAgg = await refTransaction
          .where('user', isEqualTo: user)
          .where('category',
              whereIn: categories
                  .where(
                    (element) => element.type == 'income',
                  )
                  .map(
                    (e) => e.id,
                  ))
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .aggregate(sum('value'))
          .get();

      expenseAgg = await refTransaction
          .where('user', isEqualTo: user)
          .where('category',
              whereIn: categories
                  .where(
                    (element) => element.type == 'expense',
                  )
                  .map(
                    (e) => e.id,
                  ))
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .aggregate(sum('value'))
          .get();
    } catch (e) {
      if (kDebugMode) {
        Logger.error(e.toString());
      }
      return OverviewData(totalIncome: 0, totalBalance: 0, totalExpense: 0);
    }

    var income = incomeAgg.getSum('value') ?? 0;
    var expense = expenseAgg.getSum('value') ?? 0;

    var balance = categories.fold(
      0,
      (previousValue, element) {
        if (element.type == 'income') {
          return previousValue += element.budget;
        } else {
          if (element.budget == 0) {
            return previousValue;
          } else {
            return previousValue += element.budget - element.amount;
            // TODO: truong hop amount > budget
          }
        }
      },
    );

    return OverviewData(
        totalBalance: balance,
        totalIncome: income.toInt(),
        totalExpense: expense.toInt());
  }
}
