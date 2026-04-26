import 'package:alhakim/core/utils/enums.dart';
import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/settings/domain/repo/setting_repo.dart';

class GetStaticPageContentUsecase
    extends UseCase<BaseOneResponse, StaticPageType> {
  final SettingRepo settingRepo;
  GetStaticPageContentUsecase(this.settingRepo);
  @override
  Future<Either<Failure, BaseOneResponse>> call(StaticPageType params) async {
    return await settingRepo.getStaticPageContent(params);
  }
}
