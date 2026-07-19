import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/settings/domain/repo/setting_repo.dart';
import 'package:alhakim/features/settings/domain/use_case/params/get_hospital_emergency_params.dart';
import 'package:dartz/dartz.dart';

class GetHospitalEmergencyUsecase
    implements UseCase<BaseListResponse, GetHospitalEmergencyParams> {
  final SettingRepo repository;

  GetHospitalEmergencyUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(
    GetHospitalEmergencyParams params,
  ) async {
    return await repository.getHospitalEmergencyNumbers(params: params);
  }
}
