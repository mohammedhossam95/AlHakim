import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/quick_booking_params.dart';
import 'package:alhakim/features/queue_management/data/datasources/queue_management_remote_data_source.dart';
import 'package:alhakim/features/queue_management/domain/repositories/queue_management_repository.dart';
import 'package:dartz/dartz.dart';

class QueueManagementRepositoryImpl implements QueueManagementRepository {
  final QueueManagementRemoteDataSource remoteDataSource;

  QueueManagementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BaseListResponse>> getQueueManagement({
    required String doctorId,
  }) async {
    try {
      final result = await remoteDataSource.getQueueManagement(
        doctorId: doctorId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> quickBooking({
    required QuickBookingParams params,
  }) async {
    try {
      final result = await remoteDataSource.quickBooking(params: params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> updateQueueStatus({
    required String doctorId,
    required int appointmentId,
    required String status,
  }) async {
    try {
      final result = await remoteDataSource.updateQueueStatus(
        doctorId: doctorId,
        appointmentId: appointmentId,
        status: status,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
