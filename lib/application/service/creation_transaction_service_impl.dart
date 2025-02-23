import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/infrastructure/repository/transaction_repostory_impl.dart';

import '../../domain/repository/transaction_repository.dart';
import '../../domain/service/creation_transaction_service.dart';

class CreationTransactionServiceImpl implements CreationTransactionService {
  final TransactionRepository _transactionRepository = TransactionRepositoryImpl();

  CreationTransactionServiceImpl();

  @override
  void handle(Transaction entity) {
    _transactionRepository.save(entity);
  }
}