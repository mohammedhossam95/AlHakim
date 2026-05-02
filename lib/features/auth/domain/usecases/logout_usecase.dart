import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repo.dart';

class LogoutUseCase extends UseCase<bool, LogoutParams> {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(LogoutParams params) async {
    return await repository.logout(isTeacher: params.isTeacher);
  }
}

class LogoutParams extends Equatable {
  final bool isTeacher;

  const LogoutParams({required this.isTeacher});

  @override
  List<Object?> get props => [isTeacher];
}
