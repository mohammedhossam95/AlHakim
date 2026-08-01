import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/settings/domain/repo/setting_repo.dart';
import 'package:dartz/dartz.dart';

class GetEmergencyCategoriesUsecase
    implements UseCase<BaseListResponse, NoParams> {
  final SettingRepo repository;

  GetEmergencyCategoriesUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(NoParams params) async {
    return await repository.getEmergencyCategories();
  }
}
