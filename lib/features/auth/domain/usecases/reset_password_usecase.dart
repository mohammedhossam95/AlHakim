import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:alhakim/features/auth/domain/usecases/params/reset_password_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class ResetPasswordUseCase extends UseCase<BaseOneResponse, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(
    ResetPasswordParams params,
  ) async {
    return await repository.resetPassword(params);
  }
}
