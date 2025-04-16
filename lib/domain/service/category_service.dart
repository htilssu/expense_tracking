import '../entity/category.dart';

abstract class CategoryService {
  Future<List<Category>> getCategories({int? month, int? year});

  Future<void> saveDefaultCategories();
}
