import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class DeleteUserAccountUsecase extends UseCase<BaseOneResponse, NoParams> {
  final AuthRepository repository;

  DeleteUserAccountUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(NoParams params) async {
    return await repository.deleteUserAccount();
  }
}
