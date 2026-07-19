import 'package:equatable/equatable.dart';

class NotificationPayload extends Equatable {
  final String type;
  final String? appointmentId;
  final String? doctorId;
  final String? date;
  final String title;
  final String body;

  const NotificationPayload({
    required this.type,
    this.appointmentId,
    this.doctorId,
    this.date,
    required this.title,
    required this.body,
  });

  NotificationPayload copyWith({
    String? type,
    String? appointmentId,
    String? doctorId,
    String? date,
    String? title,
    String? body,
  }) {
    return NotificationPayload(
      type: type ?? this.type,
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  List<Object?> get props => [type, appointmentId, doctorId, date, title, body];
}

class AppNotification extends Equatable {
  final String id;
  final String notificationClass;
  final String notifiableType;
  final String notifiableId;
  final NotificationPayload payload;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppNotification({
    required this.id,
    required this.notificationClass,
    required this.notifiableType,
    required this.notifiableId,
    required this.payload,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isRead => readAt != null;

  AppNotification copyWith({
    String? id,
    String? notificationClass,
    String? notifiableType,
    String? notifiableId,
    NotificationPayload? payload,
    DateTime? readAt,
    bool clearReadAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      notificationClass: notificationClass ?? this.notificationClass,
      notifiableType: notifiableType ?? this.notifiableType,
      notifiableId: notifiableId ?? this.notifiableId,
      payload: payload ?? this.payload,
      readAt: clearReadAt ? null : readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    notificationClass,
    notifiableType,
    notifiableId,
    payload,
    readAt,
    createdAt,
    updatedAt,
  ];
}
