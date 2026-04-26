import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '/core/params/change_password_params.dart';
import '/core/usecases/usecase.dart';
import '/features/settings/domain/repo/setting_repo.dart';

class SettingUseCase extends UseCase<BaseOneResponse, ChangePasswordParams> {
  final SettingRepo settingRepo;
  SettingUseCase(this.settingRepo);
  @override
  Future<Either<Failure, BaseOneResponse>> call(
    ChangePasswordParams params,
  ) async {
    return await settingRepo.settingChangePassword(params);
  }
}
