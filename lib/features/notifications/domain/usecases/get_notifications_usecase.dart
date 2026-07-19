import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:alhakim/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:dartz/dartz.dart';

class GetNotificationsUseCase extends UseCase<List<AppNotification>, NoParams> {
  final NotificationsRepository repository;

  GetNotificationsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AppNotification>>> call(NoParams params) {
    return repository.getNotifications(params: params);
  }
}
