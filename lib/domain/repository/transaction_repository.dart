import 'package:expense_tracking/domain/repository/pageable_repository.dart';

import '../entity/transaction.dart';

abstract class TransactionRepository
    extends PageableRepository<Transaction, String> {
  Future<List<Transaction>> findByCategory(String category, int page, int size);

  Future<List<Transaction>> findRecentByUserId(String userId,int page, int size);
}
