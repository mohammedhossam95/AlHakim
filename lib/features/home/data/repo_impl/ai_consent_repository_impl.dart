import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/utils/log_utils.dart';
import 'package:alhakim/features/home/data/data_source/ai_consent_local_datasource.dart';
import 'package:alhakim/features/home/domain/entity/ai_consent_entity.dart';
import 'package:alhakim/features/home/domain/repo/ai_consent_repository.dart';
import 'package:dartz/dartz.dart';

class AiConsentRepositoryImpl implements AiConsentRepository {
  final AiConsentLocalDataSource localDataSource;

  AiConsentRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AiConsent>> getConsent() async {
    try {
      final result = await localDataSource.getConsent();
      return Right<Failure, AiConsent>(result);
    } catch (error) {
      Log.e('[getConsent][${error.runtimeType}]--- $error');
      return const Right<Failure, AiConsent>(AiConsent(accepted: false));
    }
  }

  @override
  Future<Either<Failure, Unit>> acceptConsent() async {
    try {
      await localDataSource.acceptConsent();
      return const Right<Failure, Unit>(unit);
    } on AppException catch (error) {
      Log.e(
        '[acceptConsent][${error.runtimeType.toString()}]--- ${error.message}',
      );
      return Left<Failure, Unit>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> revokeConsent() async {
    try {
      await localDataSource.revokeConsent();
      return const Right<Failure, Unit>(unit);
    } on AppException catch (error) {
      Log.e(
        '[revokeConsent][${error.runtimeType.toString()}]--- ${error.message}',
      );
      return Left<Failure, Unit>(error.toFailure());
    }
  }
}
