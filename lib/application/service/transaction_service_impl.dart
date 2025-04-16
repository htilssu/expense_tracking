import 'package:expense_tracking/domain/repository/transaction_repository.dart';
import 'package:expense_tracking/domain/service/transaction_service.dart';
import 'package:expense_tracking/infrastructure/repository/transaction_repostory_impl.dart';

class TransactionServiceImpl extends TransactionService {
  TransactionServiceImpl([TransactionRepository? transactionRepository])
      : super(transactionRepository ?? TransactionRepositoryImpl());


}
