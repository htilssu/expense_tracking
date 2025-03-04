
import '../../domain/entity/category.dart';
import '../../domain/repository/category_repository.dart';
import '../../domain/service/category_service.dart';
import '../../infrastructure/repository/category_repository_impl.dart';
import '../../utils/auth.dart';

class CategoryServiceImpl implements CategoryService {
  final CategoryRepository _categoryRepository = CategoryRepositoryImpl();

  CategoryServiceImpl();

  /// Get all categories of the current user
  /// who is logged in
  ///
  /// Returns a list of [Category]
  @override
  Future<List<Category>> getCategories() {
    return _categoryRepository.getCategories();
  }

  @override
  Future<void> saveDefaultCategories() async {
    Category.defaultCategories.map(
      (e) {
        e.user = Auth.uid();
        _categoryRepository.save(e);
      },
    ).toList();
  }
}
