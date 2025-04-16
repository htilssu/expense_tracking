import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/domain/repository/transaction_repository.dart';

import '../../utils/auth.dart';

abstract class TransactionService {
  final TransactionRepository _transactionRepository;

  TransactionService(this._transactionRepository);

  Future<List<Transaction>> getRecentTransactionsByUserId() async {
    var userId = Auth.uid();
    return _transactionRepository.findRecentByUserId(userId, 1, 5);
  }

  /// Lấy các giao dịch theo tháng và loại danh mục (expense/income)
  Future<List<Transaction>> getTransactionsByMonthAndCategoryType(
      DateTime month, List<String> categoryIds) async {
    var userId = Auth.uid();
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return _transactionRepository.findByMonthAndCategoryIds(
        userId, startOfMonth, endOfMonth, categoryIds);
  }
}
