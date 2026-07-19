import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:dartz/dartz.dart';

class MarkAllNotificationsAsReadUseCase extends UseCase<String, NoParams> {
  final NotificationsRepository repository;

  MarkAllNotificationsAsReadUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.markAllNotificationsAsRead(params: params);
  }
}
