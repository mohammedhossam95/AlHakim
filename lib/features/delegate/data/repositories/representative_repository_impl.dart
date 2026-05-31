import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/delegate/data/datasources/representative_remote_data_source.dart';
import 'package:alhakim/features/delegate/domain/repositories/representative_repository.dart';
import 'package:dartz/dartz.dart';

class RepresentativeStatsRepositoryImpl
    implements RepresentativeStatsRepository {
  final RepresentativeStatsRemoteDataSource remoteDataSource;

  RepresentativeStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BaseOneResponse>> getRepresentativeStats() async {
    try {
      final result = await remoteDataSource.getRepresentativeStats();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
