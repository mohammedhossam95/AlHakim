import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, BaseOneResponse>> getNotificationsCount(
      {required NoParams params});

  Future<Either<Failure, BaseOneResponse>> getNotifications(
      {required NoParams params});
}
