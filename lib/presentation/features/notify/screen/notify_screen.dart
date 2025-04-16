import 'package:expense_tracking/application/service/notification_service_impl.dart';
import 'package:expense_tracking/domain/entity/notification.dart'
    as app_notification;
import 'package:expense_tracking/domain/service/notification_service.dart';
import 'package:expense_tracking/infrastructure/repository/notification_repository_impl.dart';
import 'package:expense_tracking/presentation/features/notify/widget/notification_item.dart';
import 'package:expense_tracking/presentation/features/notify/widget/notification_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({super.key});

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen>
    with AutomaticKeepAliveClientMixin {
  late NotificationService _notificationService;
  late Future<List<app_notification.Notification>> _notificationsFuture;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _isAllRead = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notificationService =
        NotificationServiceImpl(NotificationRepositoryImpl());
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    _notificationsFuture =
        _notificationService.getNotificationsByUserId('user123');
    final notifications = await _notificationsFuture;

    if (mounted) {
      setState(() {
        _isAllRead = !notifications.any((notification) => !notification.isRead);
        _isLoading = false;
      });
    }
  }

  void _onRefresh() async {
    await _loadNotifications();
    if (mounted) {
      _refreshController.refreshCompleted();
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    await _notificationService.markAsRead(notificationId);
    if (mounted) {
      await _loadNotifications();
    }
  }

  Future<void> _markAllAsRead() async {
    await _notificationService.markAllAsRead('user123');
    if (mounted) {
      setState(() {
        _isAllRead = true;
        _loadNotifications();
      });
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    await _notificationService.deleteNotification(notificationId);
    if (mounted) {
      await _loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_isAllRead && !_isLoading)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Đánh dấu tất cả đã đọc',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: FutureBuilder<List<app_notification.Notification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              _isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0),
              itemCount: 5,
              itemBuilder: (context, index) => const NotificationSkeleton(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi khi tải thông báo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onRefresh,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SmartRefresher(
              enablePullDown: true,
              onRefresh: _onRefresh,
              header: WaterDropMaterialHeader(
                backgroundColor: Theme.of(context).colorScheme.primary,
                color: Colors.white,
              ),
              controller: _refreshController,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final notification = snapshot.data![index];
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    child: NotificationItem(
                      notification: notification,
                      onMarkAsRead: () => _markAsRead(notification.id),
                      onDelete: () => _deleteNotification(notification.id),
                    ),
                  );
                },
              ),
            );
          }

          // Hiển thị khi không có thông báo
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Không có thông báo nào',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bạn sẽ nhận được thông báo khi có cập nhật mới',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _onRefresh,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Làm mới'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
