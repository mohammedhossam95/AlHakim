import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/add_doctor_params.dart';
import 'package:alhakim/core/params/appoinments_params.dart';
import 'package:alhakim/core/params/reschedule_params.dart';
import 'package:alhakim/features/doctors/data/datasources/doctors_remote_data_source.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BaseListResponse>> getDoctors() async {
    try {
      final result = await remoteDataSource.getDoctors();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseListResponse>> getMedicalCenterDoctors(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.getRemoteMedicalCenterDoctors(id);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> getDoctorHome(String id) async {
    try {
      final result = await remoteDataSource.getDoctorHome(id);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> toggleDoctorStatus({
    required String id,
  }) async {
    try {
      final result = await remoteDataSource.toggleDoctorStatus(id: id);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> toggleClinic({
    required String doctorId,
  }) async {
    try {
      final result = await remoteDataSource.toggleClinic(doctorId: doctorId);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> deleteDoctor(String id) async {
    try {
      final result = await remoteDataSource.deleteDoctor(id);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> addDoctor(
    AddDoctorParams params,
  ) async {
    try {
      final result = await remoteDataSource.addDoctor(params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> updateDoctor(
    AddDoctorParams params,
  ) async {
    try {
      final result = await remoteDataSource.updateDoctor(params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> closeClinicToday({
    required String doctorId,
  }) async {
    try {
      final result = await remoteDataSource.closeClinicToday(
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
  Future<Either<Failure, BaseListResponse>> getDoctorAppoinmentsForDay({
    required AppoinmentsParams params,
  }) async {
    try {
      final result = await remoteDataSource.getDoctorAppoinmentsForDay(
        params: params,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> reschedule({
    required RescheduleParams params,
  }) async {
    try {
      final result = await remoteDataSource.reschedule(params: params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
