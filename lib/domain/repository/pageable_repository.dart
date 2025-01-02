import 'package:expense_tracking/domain/repository/repository.dart';

abstract class PageableRepository<T, ID> implements Repository<T, ID> {
  Future<List<T>> findAll(int page, int size);

  //query by field in firestore
  Future<List<T>> findByField(Map<String, dynamic> query, int page, int size);
}
