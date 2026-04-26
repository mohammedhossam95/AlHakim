import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class GetCountriesUseCase extends UseCase<BaseListResponse, NoParams> {
  final AuthRepository repository;

  GetCountriesUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(NoParams params) async {
    return await repository.getCountries();
  }
}
