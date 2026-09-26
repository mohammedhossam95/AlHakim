import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/home/domain/entity/ai_consent_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AiConsentRepository {
  Future<Either<Failure, AiConsent>> getConsent();
  Future<Either<Failure, Unit>> acceptConsent();
  Future<Either<Failure, Unit>> revokeConsent();
}
