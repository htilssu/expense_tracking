import 'package:expense_tracking/domain/entity/notification.dart';
import 'package:expense_tracking/domain/repository/notification_repository.dart';
import 'package:expense_tracking/domain/service/notification_service.dart';

class NotificationServiceImpl implements NotificationService {
  final NotificationRepository _notificationRepository;

  NotificationServiceImpl(this._notificationRepository);

  @override
  Future<List<Notification>> getNotificationsByUserId(String userId) {
    return _notificationRepository.getNotificationsByUserId(userId);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _notificationRepository.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) {
    return _notificationRepository.markAllAsRead(userId);
  }

  @override
  Future<void> deleteNotification(String notificationId) {
    return _notificationRepository.deleteNotification(notificationId);
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final notifications =
        await _notificationRepository.getNotificationsByUserId(userId);
    return notifications.where((n) => !n.isRead).length;
  }
}
