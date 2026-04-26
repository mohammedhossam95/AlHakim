import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';

import '/core/base_classes/base_one_response.dart';
import '../../domain/entities/get_notifications_response.dart';

class GetNotificationsModel extends BaseOneResponse {
  const GetNotificationsModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory GetNotificationsModel.fromJson(Map<String, dynamic> json) =>
      GetNotificationsModel(
        success: json['success'],
        message: json['message'],
        data: json['data'] == null
            ? null
            : NotificationDataModel.fromJson(json['data']),
      );
}

class NotificationDataModel extends NotificationData {
  const NotificationDataModel({super.notifications, super.unreadCount});

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      NotificationDataModel(
        notifications: json['notifications'] == null
            ? null
            : List<MyNotificationModel>.from(
                json['notifications'].map(
                  (x) => MyNotificationModel.fromJson(x),
                ),
              ),
        unreadCount: json['unread_count'],
      );
  Map<String, dynamic> toJson() => {
    "notifications": notifications == null
        ? null
        : List<dynamic>.from(
            notifications!.map((x) => (x as MyNotificationModel?)?.toJson()),
          ),
    "unread_count": unreadCount,
  };
}

class MyNotificationModel extends MyNotification {
  const MyNotificationModel({
    super.id,
    super.type,
    super.title,
    super.message,
    super.imageUrl,
    super.data,
    super.read,
    super.createdAt,
    super.createdAtHuman,
    super.user,
  });

  factory MyNotificationModel.fromJson(
    Map<String, dynamic> json,
  ) => MyNotificationModel(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    message: json["message"],
    imageUrl: json["image_url"],
    data: json["data"] == null ? null : NotifyDataModel.fromJson(json["data"]),
    read: json["read"],
    createdAt: json["created_at"],
    createdAtHuman: json["created_at_human"],
    //user: json["vendor"] == null ? null : VendorModel.fromJson(json["vendor"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "message": message,
    "image_url": imageUrl,
    "data": (data as NotifyDataModel?)?.toJson(),
    "read": read,
    "created_at": createdAt,
    "created_at_human": createdAtHuman,
    "user": (user as UserModel?)?.toJson(),
  };
}

class NotifyDataModel extends NotifyData {
  const NotifyDataModel({super.friendshipId});

  factory NotifyDataModel.fromJson(Map<String, dynamic> json) =>
      NotifyDataModel(friendshipId: json["friendship_id"]);

  Map<String, dynamic> toJson() => {"friendship_id": friendshipId};
}
