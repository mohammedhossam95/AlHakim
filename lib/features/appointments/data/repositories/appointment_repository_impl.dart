import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:alhakim/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:dartz/dartz.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource remoteDataSource;

  AppointmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BaseListResponse>> getAppointments() async {
    try {
      final result = await remoteDataSource.getAppointments();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> cancelAppointment({
    required String appointmentId,
  }) async {
    try {
      final result = await remoteDataSource.cancelAppointment(
        appointmentId: appointmentId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> getQueueStatus({
    required String appointmentId,
  }) async {
    try {
      final result = await remoteDataSource.getQueueStatus(
        appointmentId: appointmentId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
