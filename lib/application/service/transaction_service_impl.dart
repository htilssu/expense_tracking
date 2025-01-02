import 'package:expense_tracking/infrastructure/repository/transaction_repostory_impl.dart';

import '../../domain/service/transaction_service.dart';

class TransactionServiceImpl extends TransactionService {
  TransactionServiceImpl() : super(TransactionRepositoryImpl());
}
