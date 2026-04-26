import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notifications_repo.dart';

class NotificationsCountUseCase extends UseCase<BaseOneResponse, NoParams> {
  final NotificationsRepository repository;

  NotificationsCountUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(NoParams params) async {
    return await repository.getNotificationsCount(params: params);
  }
}
