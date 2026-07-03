import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/delegate/data/datasources/medical_center_remote_data_source.dart';
import 'package:alhakim/features/delegate/domain/repositories/medical_center_repository.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/add_medical_center_params.dart';
import 'package:dartz/dartz.dart';

class MedicalCenterRepositoryImpl implements MedicalCenterRepository {
  final MedicalCenterRemoteDataSource remoteDataSource;

  MedicalCenterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BaseListResponse>> getMedicalCenters() async {
    try {
      final result = await remoteDataSource.getMedicalCenters();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> addMedicalCenter({
    required AddMedicalCenterParams params,
  }) async {
    try {
      final result = await remoteDataSource.addMedicalCenter(params: params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> updateMedicalCenter({
    required AddMedicalCenterParams params,
  }) async {
    try {
      final result = await remoteDataSource.updateMedicalCenter(params: params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> deleteMedicalCenter({
    required String medicalCenterId,
  }) async {
    try {
      final result = await remoteDataSource.deleteMedicalCenter(
        medicalCenterId: medicalCenterId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> toggleMedicalCenterStatus({
    required String medicalCenterId,
  }) async {
    try {
      final result = await remoteDataSource.toggleMedicalCenterStatus(
        medicalCenterId: medicalCenterId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
