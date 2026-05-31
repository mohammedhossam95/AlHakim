import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class CompleteProfileUsecase
    implements UseCase<AuthRespModel, CompleteProfileParams> {
  final AuthRepository repository;

  CompleteProfileUsecase({required this.repository});

  @override
  Future<Either<Failure, AuthRespModel>> call(
    CompleteProfileParams params,
  ) async {
    return await repository.completeProfile(params: params);
  }
}
