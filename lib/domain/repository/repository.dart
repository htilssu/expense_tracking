abstract class Repository<T, ID> {
  Future<T?> findById(ID id);

  Future<T> update(T entity);

  Future<void> delete(ID id);
}
