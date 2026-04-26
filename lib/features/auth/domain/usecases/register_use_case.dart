import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class RegisterUseCase extends UseCase<BaseOneResponse, AuthParams> {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(AuthParams params) async {
    return await repository.register(params);
  }
}
