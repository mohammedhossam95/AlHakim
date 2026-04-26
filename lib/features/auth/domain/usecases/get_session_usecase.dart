import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/enums.dart';
import '../repositories/auth_repo.dart';

class GetSessionStatusUseCase extends UseCase<SessionStatus, NoParams> {
  final AuthRepository repository;

  GetSessionStatusUseCase({required this.repository});

  @override
  Future<Either<Failure, SessionStatus>> call(NoParams params) async {
    return await repository.getUserSession(params: params);
  }
}
