import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/settings/domain/repo/setting_repo.dart';
import 'package:dartz/dartz.dart';

class GetAppSettingUsecase extends UseCase<BaseOneResponse, NoParams> {
  final SettingRepo repo;

  GetAppSettingUsecase({required this.repo});

  @override
  Future<Either<Failure, BaseOneResponse>> call(NoParams params) async {
    return await repo.getAppSetting();
  }
}
