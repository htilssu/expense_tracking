import 'package:expense_tracking/domain/entity/notification.dart';

abstract class NotificationService {
  Future<List<Notification>> getNotificationsByUserId(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
  Future<int> getUnreadCount(String userId);
}
