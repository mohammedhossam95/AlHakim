import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:alhakim/features/auth/domain/usecases/params/register_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class RegisterUseCase extends UseCase<BaseOneResponse, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(RegisterParams params) async {
    return await repository.register(params);
  }
}
