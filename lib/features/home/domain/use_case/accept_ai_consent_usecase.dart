import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/home/domain/repo/ai_consent_repository.dart';
import 'package:dartz/dartz.dart';

class AcceptAiConsentUseCase extends UseCase<Unit, NoParams> {
  final AiConsentRepository repository;

  AcceptAiConsentUseCase({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.acceptConsent();
  }
}
