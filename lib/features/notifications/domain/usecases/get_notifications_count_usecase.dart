import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:alhakim/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:dartz/dartz.dart';

class NotificationsCountUseCase extends UseCase<int, NoParams> {
  final NotificationsRepository repository;

  NotificationsCountUseCase({required this.repository});

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    final result = await repository.getNotifications(params: params);
    return result.map(
      (List<AppNotification> notifications) =>
          notifications.where((notification) => !notification.isRead).length,
    );
  }
}
