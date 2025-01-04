import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/domain/repository/transaction_repository.dart';

abstract class TransactionService {
  final TransactionRepository _transactionRepository;

  TransactionService(this._transactionRepository);

  Future<List<Transaction>> getRecentTransactions() async {
    return _transactionRepository.findRecent(1, 5);
  }
}
