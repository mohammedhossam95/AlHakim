import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:alhakim/features/notifications/domain/usecases/params/mark_notification_as_read_params.dart';
import 'package:dartz/dartz.dart';

class MarkNotificationAsReadUseCase
    extends UseCase<String, MarkNotificationAsReadParams> {
  final NotificationsRepository repository;

  MarkNotificationAsReadUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(MarkNotificationAsReadParams params) {
    return repository.markNotificationAsRead(params: params);
  }
}
