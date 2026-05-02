import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/enums.dart';
import '../repositories/auth_repo.dart';

class SaveUserTypeUseCase extends UseCase<bool, UserTypeParams> {
  final AuthRepository repository;

  SaveUserTypeUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(UserTypeParams params) async {
    return await repository.saveUserType(params: params);
  }
}

class UserTypeParams extends Equatable {
  final UserType userType;

  const UserTypeParams({required this.userType});

  @override
  List<Object?> get props => <Object?>[userType];
}
