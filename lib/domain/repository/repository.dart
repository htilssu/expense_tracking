abstract class Repository<T,ID> {
  T findById(ID id);
}