import 'package:uuid/uuid.dart';

import 'timestamp_entity.dart';

class Transaction extends BaseTimeStampEntity {
  late String id;
  String note;
  double value;
  String category;
  final String user;

  Transaction(this.note, this.value, this.category, this.user) {
    id = Uuid().v4();
  }

  Transaction.withId(this.id, this.note, this.value, this.category, this.user);

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction.withId(
      map['id'] as String,
      map['note'] as String,
      map['value'] as double,
      map['category'] as String,
      map['user'] as String,
    )..timeStampFromMap(map);
  }

  // Convert a Transaction to a Map
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'value': value,
      'category': category,
      'user': user,
      ...super.toMap(),
    };
  }

  @override
  List<Object?> get props => [id, note, value, category, user];
}

enum TransactionType { income, expense }
