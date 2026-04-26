import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/notifications_repo.dart';

class GetNotificationsUseCase extends UseCase<BaseOneResponse, NoParams> {
  final NotificationsRepository repository;

  GetNotificationsUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(NoParams params) async {
    return await repository.getNotifications(params: params);
  }
}
