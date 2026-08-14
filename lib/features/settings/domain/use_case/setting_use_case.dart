import 'package:dartz/dartz.dart';

import '/core/base_classes/base_list_response.dart';
import '/core/error/failures.dart';
import '/core/params/change_password_params.dart';
import '/core/usecases/usecase.dart';
import '/features/settings/domain/repo/setting_repo.dart';

class SettingUseCase extends UseCase<BaseListResponse, ChangePasswordParams> {
  final SettingRepo settingRepo;
  SettingUseCase(this.settingRepo);
  @override
  Future<Either<Failure, BaseListResponse>> call(
    ChangePasswordParams params,
  ) async {
    return await settingRepo.settingChangePassword(params);
  }
}
