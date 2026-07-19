class MarkNotificationAsReadParams {
  final String notificationId;

  const MarkNotificationAsReadParams({required this.notificationId});

  MarkNotificationAsReadParams copyWith({String? notificationId}) {
    return MarkNotificationAsReadParams(
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
