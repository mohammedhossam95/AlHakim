import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/specialities/data/datasources/specialty_remote_data_source.dart';
import 'package:alhakim/features/specialities/domain/repositories/specialty_repository.dart';
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
  Future<Either<Failure, BaseListResponse>> getSpecialtyDoctors(String id) async {
    try {
      final result = await remoteDataSource.getSpecialtyDoctors(id);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
