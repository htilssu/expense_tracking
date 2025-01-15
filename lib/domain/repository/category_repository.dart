import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/repository/repository.dart';

abstract class CategoryRepository extends Repository<Category, String> {
  Future<List<Category>> getCategories();
}
