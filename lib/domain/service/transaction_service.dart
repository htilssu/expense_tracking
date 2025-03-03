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
}
