part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<AppNotification> notifications;
  final Set<String> readingNotificationIds;
  final bool isMarkingAllAsRead;
  final String? errorMessage;
  final String? actionMessage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.readingNotificationIds = const {},
    this.isMarkingAllAsRead = false,
    this.errorMessage,
    this.actionMessage,
  });

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  bool get hasUnreadNotifications => unreadCount > 0;

  bool isMarkingNotificationAsRead(String id) {
    return readingNotificationIds.contains(id);
  }

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? notifications,
    Set<String>? readingNotificationIds,
    bool? isMarkingAllAsRead,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? actionMessage,
    bool clearActionMessage = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      readingNotificationIds:
          readingNotificationIds ?? this.readingNotificationIds,
      isMarkingAllAsRead: isMarkingAllAsRead ?? this.isMarkingAllAsRead,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    readingNotificationIds,
    isMarkingAllAsRead,
    errorMessage,
    actionMessage,
  ];
}
