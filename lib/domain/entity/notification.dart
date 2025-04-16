import 'package:expense_tracking/domain/entity/timestamp_entity.dart';
import 'package:uuid/uuid.dart';

class Notification extends BaseTimeStampEntity {
  late String id;
  String title;
  String message;
  String type; // 'transaction', 'budget', 'reminder', 'system'
  bool isRead;
  String userId;
  String? transactionId;
  String? imageUrl;

  Notification(
    this.title,
    this.message,
    this.type,
    this.userId, {
    this.isRead = false,
    this.transactionId,
    this.imageUrl,
    DateTime? createdAt,
  }) {
    id = const Uuid().v4();
    if (createdAt != null) {
      this.createdAt = createdAt;
    }
  }

  Notification.withId(
    this.id,
    this.title,
    this.message,
    this.type,
    this.userId, {
    this.isRead = false,
    this.transactionId,
    this.imageUrl,
    DateTime? createdAt,
  }) {
    if (createdAt != null) {
      this.createdAt = createdAt;
    }
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification.withId(
      map['id'] as String,
      map['title'] as String,
      map['message'] as String,
      map['type'] as String,
      map['userId'] as String,
      isRead: map['isRead'] as bool,
      transactionId: map['transactionId'] as String?,
      imageUrl: map['imageUrl'] as String?,
    )..timeStampFromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'userId': userId,
      'isRead': isRead,
      'transactionId': transactionId,
      'imageUrl': imageUrl,
      ...super.toMap(),
    };
  }

  @override
  List<Object?> get props =>
      [id, title, message, type, userId, isRead, transactionId];
}
