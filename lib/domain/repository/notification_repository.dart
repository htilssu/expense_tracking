import 'package:expense_tracking/domain/entity/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotificationsByUserId(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
}
