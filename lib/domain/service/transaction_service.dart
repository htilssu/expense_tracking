import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/domain/repository/transaction_repository.dart';
import 'package:expense_tracking/exceptions/authenticate_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class TransactionService {
  final TransactionRepository _transactionRepository;

  TransactionService(this._transactionRepository);

  Future<List<Transaction>> getRecentTransactionsByUserId() async {
    if (FirebaseAuth.instance.currentUser != null) {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      return _transactionRepository.findRecentByUserId(userId, 1, 5);
    } else {
      throw AuthenticateException("User is not authenticated");
    }
  }
}
