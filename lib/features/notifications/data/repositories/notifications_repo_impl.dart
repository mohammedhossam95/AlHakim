import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/log_utils.dart';
import '../../data/datasources/notifications_remote_datasource.dart';
import '../../domain/repositories/notifications_repo.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remote;

  NotificationsRepositoryImpl({
    required this.remote,
  });

  @override
  Future<Either<Failure, BaseOneResponse>> getNotificationsCount(
      {required NoParams params}) async {
    try {
      final response = await remote.getRemoteNotificationsCount();
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      Log.e(
          '[Notifications count][${error.runtimeType.toString()}]--- ${error.message}');
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> getNotifications(
      {required NoParams params}) async {
    try {
      final response = await remote.getRemoteNotifications();
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      Log.e(
          '[getNotifications] [${error.runtimeType.toString()}] ---- ${error.message}');
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }
}
