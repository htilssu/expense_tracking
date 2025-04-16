import 'package:expense_tracking/domain/repository/repository.dart';

abstract class PageableRepository<T, ID> implements Repository<T, ID> {
  /// Find all entities in firestore with pagination
  /// [page] is the page number
  /// [size] is the number of entities per page
  /// Returns a list of entities
  Future<List<T>> findAll(int page, int size);

  /// Find entities by category in firestore with pagination
  /// [query] is the query to filter the entities
  /// [page] is the page number
  /// [size] is the number of entities per page
  ///
  /// Returns a list of entities
  Future<List<T>> findByField(Map<String, dynamic> query, int page, int size);
}
