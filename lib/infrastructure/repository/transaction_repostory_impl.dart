import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:expense_tracking/domain/entity/transaction.dart';

import '../../domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  fs.CollectionReference<Map<String, dynamic>> ref =
      fs.FirebaseFirestore.instance.collection('transactions');

  @override
  Future<void> delete(String id) async {
    await ref.doc(id).delete();
  }

  @override
  Future<List<Transaction>> findAll(int page, int size) async {
    return ref.limit(size).get().then((value) => value.docs
        .map((e) => Transaction.fromMap(e.data()))
        .toList(growable: false));
  }

  @override
  Future<List<Transaction>> findByCategory(
      String category, int page, int size) async {
    return ref.where('category', isEqualTo: category).limit(size).get().then(
        (value) =>
            value.docs.map((e) => Transaction.fromMap(e.data())).toList());
  }

  @override
  Future<List<Transaction>> findByField(
      Map<String, dynamic> query, int page, int size) async {
    fs.Query<Map<String, dynamic>> q = ref;
    query.forEach((key, value) {
      q = q.where(key, isEqualTo: value);
    });

    return q.limit(size).get().then((value) => value.docs
        .map((e) => Transaction.fromMap(e.data()))
        .toList(growable: false));
  }

  @override
  Future<Transaction?> findById(String id) async {
    return ref.doc(id).get().then((value) {
      if (value.exists) {
        return Transaction.fromMap(value.data()!);
      }
      return null;
    });
  }

  @override
  Future<Transaction> save(Transaction entity) async {
    return ref.doc(entity.id).set(entity.toMap()).then((value) => entity);
  }

  @override
  Future<Transaction> update(Transaction entity) async {
    return ref.doc(entity.id).update(entity.toMap()).then((value) => entity);
  }

  @override
  Future<List<Transaction>> findRecentByUserId(
      String userId, int page, int size) {
    if (size > 30) {
      throw Exception('Size must be less than 30');
    }

    if (page < 0) {
      throw Exception('Page must be greater than 0');
    }

    return ref
        .where('user', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(size)
        .get()
        .then((value) =>
            value.docs.map((e) => Transaction.fromMap(e.data())).toList());
  }
}
