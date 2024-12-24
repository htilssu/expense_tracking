import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> delete(String id) async {
    await db.collection("users").doc(id).delete();
  }

  @override
  Future<User> update(User entity) async {
    throw UnimplementedError();
  }

  @override
  Future<User?> findById(String id) async {
    // TODO: implement findById
    throw UnimplementedError();
  }
}
