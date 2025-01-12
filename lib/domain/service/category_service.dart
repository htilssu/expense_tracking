import '../entity/category.dart';

abstract class CategoryService {
  Future<List<Category>> getCategories();

  Future<void> saveDefaultCategories();
}
