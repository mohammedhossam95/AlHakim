import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/specialities/data/datasources/specialty_remote_data_source.dart';
import 'package:alhakim/features/specialities/domain/repositories/specialty_repository.dart';
import 'package:alhakim/features/specialities/domain/usecases/params/get_specialty_doctors_params.dart';
import 'package:dartz/dartz.dart';

class SpecialtyRepositoryImpl implements SpecialtyRepository {
  final SpecialtyRemoteDataSource remoteDataSource;

  SpecialtyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BaseListResponse>> getSpecialties() async {
    try {
      final result = await remoteDataSource.getSpecialties();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseListResponse>> getSpecialtyDoctors(
    GetSpecialtyDoctorsParams params,
  ) async {
    try {
      final result = await remoteDataSource.getSpecialtyDoctors(params);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
