import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/settings/domain/entity/support_phone_response.dart';
import '/features/settings/domain/repo/setting_repo.dart';

class GetSupportPhoneUseCase extends UseCase<SupportPhoneResp, NoParams> {
  final SettingRepo settingRepo;
  GetSupportPhoneUseCase(this.settingRepo);
  @override
  Future<Either<Failure, SupportPhoneResp>> call(NoParams params) async {
    return await settingRepo.getSupportPhone();
  }
}
