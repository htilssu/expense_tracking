import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/repository/category_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<List<Category>> getCategories() {
    var fireAuth = FirebaseAuth.instance;
    return docRef
        .where('user', isEqualTo: fireAuth.currentUser!.uid)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Category.fromMap(e.data()),
              )
              .toList(),
        );
  }
}
