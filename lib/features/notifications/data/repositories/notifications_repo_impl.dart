import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/core/utils/log_utils.dart';
import 'package:alhakim/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:alhakim/features/notifications/data/models/notification_model.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:alhakim/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:alhakim/features/notifications/domain/usecases/params/mark_notification_as_read_params.dart';
import 'package:dartz/dartz.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remote;

  NotificationsRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    required NoParams params,
  }) async {
    try {
      final response = await remote.getRemoteNotifications();
      final notifications = (response.data ?? <NotificationModel>[])
          .whereType<AppNotification>()
          .toList();
      return Right<Failure, List<AppNotification>>(notifications);
    } on AppException catch (error) {
      Log.e('[getNotifications] [${error.runtimeType}] ---- ${error.message}');
      return Left<Failure, List<AppNotification>>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, String>> markNotificationAsRead({
    required MarkNotificationAsReadParams params,
  }) async {
    final notificationId = params.notificationId.trim();
    if (notificationId.isEmpty) {
      return const Left<Failure, String>(
        ServerFailure(message: 'Notification id is required.'),
      );
    }

    try {
      final response = await remote.markNotificationAsRead(
        MarkNotificationAsReadParams(notificationId: notificationId),
      );
      return Right<Failure, String>(response.message ?? '');
    } on AppException catch (error) {
      Log.e(
        '[markNotificationAsRead] [${error.runtimeType}] ---- ${error.message}',
      );
      return Left<Failure, String>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, String>> markAllNotificationsAsRead({
    required NoParams params,
  }) async {
    try {
      final response = await remote.markAllNotificationsAsRead();
      return Right<Failure, String>(response.message ?? '');
    } on AppException catch (error) {
      Log.e(
        '[markAllNotificationsAsRead] [${error.runtimeType}] ---- ${error.message}',
      );
      return Left<Failure, String>(error.toFailure());
    }
  }
}
