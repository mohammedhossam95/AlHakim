import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/utils/enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repo.dart';

class SaveSessionStatusUseCase extends UseCase<bool, SessionStatusParams> {
  final AuthRepository repository;

  SaveSessionStatusUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(SessionStatusParams params) async {
    return await repository.saveUserSession(params: params);
  }
}

class SessionStatusParams extends Equatable {
  final SessionStatus status;

  const SessionStatusParams({required this.status});

  @override
  List<Object?> get props => <Object?>[status];
}
