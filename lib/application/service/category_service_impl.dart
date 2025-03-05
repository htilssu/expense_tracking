import '../../domain/entity/category.dart';
import '../../domain/repository/category_repository.dart';
import '../../domain/service/category_service.dart';
import '../../infrastructure/repository/category_repository_impl.dart';
import '../../utils/auth.dart';

class CategoryServiceImpl implements CategoryService {
  late CategoryRepository categoryRepository;

  CategoryServiceImpl({CategoryRepository? categoryRepository}) {
    this.categoryRepository = categoryRepository ?? CategoryRepositoryImpl();
  }

  /// Get all categories of the current user
  /// who is logged in
  ///
  /// Returns a list of [Category]
  @override
  Future<List<Category>> getCategories() async {
    return categoryRepository.getCategories();
  }

  @override
  Future<void> saveDefaultCategories() async {
    Category.defaultCategories.map(
      (e) {
        e.user = Auth.uid();
        categoryRepository.save(e);
      },
    ).toList();
  }
}
