import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/repository/category_repository.dart';
import 'package:expense_tracking/utils/auth.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CollectionReference<Map<String, dynamic>> docRef =
      FirebaseFirestore.instance.collection('categories');

  @override
  Future<void> delete(String id) async {
    docRef.doc(id).delete();
  }

  @override
  Future<Category?> findById(String id) async {
    return docRef.doc(id).get().then(
      (value) {
        if (value.exists) {
          return Category.fromMap(value.data()!);
        }
        return null;
      },
    );
  }

  @override
  Future<Category> save(Category entity) {
    return docRef.add(entity.toMap()).then(
      (value) {
        docRef.doc(value.id).update({'id': value.id});
        return entity..id = value.id;
      },
    );
  }

  @override
  Future<Category> update(Category entity) {
    return docRef.doc(entity.id).update(entity.toMap()).then(
      (_) {
        return entity;
      },
    );
  }

  @override
  Future<List<Category>> getCategories({int? month, int? year}) {
    var userId = Auth.uid();
    var query = docRef.where('user', isEqualTo: userId);

    // Thêm điều kiện lọc theo tháng và năm nếu có
    if (month != null && year != null) {
      // Ở đây chúng ta giả định rằng có một trường 'createdAt' hoặc tương tự
      // trong danh mục để lọc
      // Lưu ý: Logic này phụ thuộc vào cách lưu trữ dữ liệu trong database
      DateTime startDate = DateTime(year, month, 1);
      DateTime endDate =
          DateTime(year, month + 1, 0); // Ngày cuối cùng của tháng

      query = query.where('createdAt', isGreaterThanOrEqualTo: startDate);
      query = query.where('createdAt', isLessThanOrEqualTo: endDate);
    }

    return query.get().then(
          (value) => value.docs
              .map(
                (e) => Category.fromMap(e.data()),
              )
              .toList(),
        );
  }
}
