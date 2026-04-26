import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/settings/domain/repo/setting_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class UpdateUserProfileUseCase extends UseCase<BaseOneResponse, AuthParams> {
  final SettingRepo repository;

  UpdateUserProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(AuthParams params) async {
    return await repository.updateUserProfile(params);
  }
}
