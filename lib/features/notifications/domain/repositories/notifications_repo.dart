import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:alhakim/features/notifications/domain/usecases/params/mark_notification_as_read_params.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    required NoParams params,
  });

  Future<Either<Failure, String>> markNotificationAsRead({
    required MarkNotificationAsReadParams params,
  });

  Future<Either<Failure, String>> markAllNotificationsAsRead({
    required NoParams params,
  });
}
