import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '/core/params/contact_us_param.dart';
import '/core/usecases/usecase.dart';
import '/features/settings/domain/repo/setting_repo.dart';

class ContactUsUseCase extends UseCase<BaseOneResponse, ContactUsParam> {
  final SettingRepo settingRepo;
  ContactUsUseCase(this.settingRepo);
  @override
  Future<Either<Failure, BaseOneResponse>> call(ContactUsParam params) async {
    return await settingRepo.contactUsMethod(params);
  }
}
