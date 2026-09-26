import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/home/domain/entity/ai_consent_entity.dart';
import 'package:alhakim/features/home/domain/repo/ai_consent_repository.dart';
import 'package:dartz/dartz.dart';

class GetAiConsentUseCase extends UseCase<AiConsent, NoParams> {
  final AiConsentRepository repository;

  GetAiConsentUseCase({required this.repository});

  @override
  Future<Either<Failure, AiConsent>> call(NoParams params) {
    return repository.getConsent();
  }
}
