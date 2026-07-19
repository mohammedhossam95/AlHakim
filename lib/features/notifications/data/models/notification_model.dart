import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';

class NotificationsRespModel extends BaseListResponse {
  const NotificationsRespModel({super.status, super.message, super.data});

  factory NotificationsRespModel.fromJson(Map<String, dynamic> json) {
    return NotificationsRespModel(
      status: json['status'],
      message: json['message']?.toString(),
      data: json['data'] == null
          ? <NotificationModel>[]
          : List<NotificationModel>.from(
              (json['data'] as List).map(
                (x) => NotificationModel.fromJson(
                  x as Map<String, dynamic>? ?? const {},
                ),
              ),
            ),
    );
  }
}

class NotificationPayloadModel extends NotificationPayload {
  const NotificationPayloadModel({
    required super.type,
    super.appointmentId,
    super.doctorId,
    super.date,
    required super.title,
    required super.body,
  });

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) {
    return NotificationPayloadModel(
      type: json['type']?.toString() ?? '',
      appointmentId: json['appointment_id']?.toString(),
      doctorId: json['doctor_id']?.toString(),
      date: json['date']?.toString(),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'appointment_id': appointmentId,
    'doctor_id': doctorId,
    'date': date,
    'title': title,
    'body': body,
  };
}

class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.notificationClass,
    required super.notifiableType,
    required super.notifiableId,
    required NotificationPayloadModel super.payload,
    required super.readAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      notificationClass: json['type']?.toString() ?? '',
      notifiableType: json['notifiable_type']?.toString() ?? '',
      notifiableId: json['notifiable_id']?.toString() ?? '',
      payload: NotificationPayloadModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? const {},
      ),
      readAt: DateTime.tryParse(json['read_at']?.toString() ?? ''),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': notificationClass,
    'notifiable_type': notifiableType,
    'notifiable_id': notifiableId,
    'data': (payload as NotificationPayloadModel).toJson(),
    'read_at': readAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
