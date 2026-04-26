import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class GetAllCitiesUseCase extends UseCase<BaseListResponse, AuthParams> {
  final AuthRepository repository;

  GetAllCitiesUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(AuthParams params) async {
    return await repository.getAllCities(params);
  }
}
