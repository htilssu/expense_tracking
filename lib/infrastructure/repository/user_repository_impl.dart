import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final CollectionReference<Map<String, dynamic>> db =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<void> delete(String id) async {
    await db.doc(id).delete();
  }

  @override
  Future<User?> findByEmail(String email) async {
    var refDocument = await db.where('email', isEqualTo: email).get();

    if (refDocument.docs.isNotEmpty) {
      return User.fromMap(refDocument.docs.first.data());
    }
    return null;
  }

  @override
  Future<User?> findById(String id) async {
    var refDocument = await db.doc(id).get();
    if (refDocument.exists) {
      return User.fromMap(refDocument.data()!);
    }
    return null;
  }

  @override
  Future<User> update(User entity) async {
    await db.doc(entity.id).update(entity.toMap());
    return entity;
  }

  @override
  Future<User> save(User entity) async {
    await db.doc(entity.id).set(entity.toMap());
    return User.fromMap((await db.doc(entity.id).get()).data()!);
  }
}
