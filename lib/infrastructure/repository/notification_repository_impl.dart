import 'package:expense_tracking/domain/entity/notification.dart';
import 'package:expense_tracking/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  // Danh sách thông báo mẫu
  final List<Notification> _mockNotifications = [
    Notification(
      'Vượt ngân sách',
      'Bạn đã vượt ngân sách cho danh mục Ăn uống tháng này',
      'budget',
      'user123',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      'Giao dịch mới',
      'Giao dịch 500.000đ cho Ăn uống đã được tạo',
      'transaction',
      'user123',
      transactionId: 'trans123',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Notification(
      'Nhắc nhở',
      'Đừng quên cập nhật chi tiêu hàng ngày của bạn',
      'reminder',
      'user123',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Notification(
      'Báo cáo tuần',
      'Báo cáo chi tiêu tuần của bạn đã sẵn sàng để xem',
      'system',
      'user123',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Notification(
      'Tiết kiệm thành công',
      'Chúc mừng! Bạn đã tiết kiệm được 200.000đ so với tháng trước',
      'system',
      'user123',
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/2278/2278992.png',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Notification(
      'Giao dịch mới',
      'Giao dịch 1.200.000đ cho Nhà cửa đã được tạo',
      'transaction',
      'user123',
      transactionId: 'trans456',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Notification(
      'Vượt ngân sách',
      'Bạn đã vượt ngân sách cho danh mục Di chuyển tháng này',
      'budget',
      'user123',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Notification(
      'Cập nhật ứng dụng',
      'Phiên bản mới của ứng dụng đã sẵn sàng để cập nhật',
      'system',
      'user123',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  @override
  Future<List<Notification>> getNotificationsByUserId(String userId) async {
    // Giả lập độ trễ của mạng
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockNotifications;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    // Giả lập độ trễ của mạng
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _mockNotifications[index].isRead = true;
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    // Giả lập độ trễ của mạng
    await Future.delayed(const Duration(milliseconds: 300));
    for (var notification in _mockNotifications) {
      notification.isRead = true;
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    // Giả lập độ trễ của mạng
    await Future.delayed(const Duration(milliseconds: 300));
    _mockNotifications.removeWhere((n) => n.id == notificationId);
  }
}
