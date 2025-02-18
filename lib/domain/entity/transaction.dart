import 'timestamp_entity.dart';

class Transaction extends BaseTimeStampEntity {
  late final String id;
  final String note;
  final double value;
  final String category;
  final String user;

  Transaction(this.id, this.note, this.value, this.category, this.user);

  factory Transaction.fromMap(Map<String, dynamic> map) {
    var t = Transaction(
      map['id'] as String,
      map['note'] as String,
      map['value'] as double,
      map['category'] as String,
      map['user'] as String,
    );
    t.timeStampFromMap(map);

    return t;
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
}
