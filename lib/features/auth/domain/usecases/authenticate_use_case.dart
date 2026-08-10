import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:alhakim/features/auth/domain/usecases/params/authenticate_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AuthenticateUseCase extends UseCase<BaseOneResponse, AuthenticateParams> {
  final AuthRepository repository;

  AuthenticateUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(
    AuthenticateParams params,
  ) async {
    return await repository.authenticate(params);
  }
}
