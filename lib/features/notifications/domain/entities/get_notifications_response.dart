import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

class NotificationData extends Equatable {
  final int? unreadCount;
  final List<MyNotification>? notifications;

  const NotificationData({this.unreadCount, this.notifications});

  @override
  List<Object?> get props => <Object?>[unreadCount, notifications];
}

class MyNotification extends Equatable {
  final int? id;
  final String? type;
  final String? title;
  final String? message;
  final String? imageUrl;
  final NotifyData? data;
  final bool? read;
  final String? createdAt;
  final String? createdAtHuman;
  final UserEntity? user;

  const MyNotification({
    this.id,
    this.type,
    this.title,
    this.message,
    this.imageUrl,
    this.data,
    this.read,
    this.createdAt,
    this.createdAtHuman,
    this.user,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    message,
    imageUrl,
    data,
    read,
    createdAt,
    createdAtHuman,
    user,
  ];
}

class NotifyData extends Equatable {
  final int? friendshipId;

  const NotifyData({this.friendshipId});

  @override
  List<Object?> get props => [friendshipId];
}
