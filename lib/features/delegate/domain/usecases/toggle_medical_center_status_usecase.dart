import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/delegate/domain/repositories/medical_center_repository.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/toggle_medical_center_status_params.dart';
import 'package:dartz/dartz.dart';

class ToggleMedicalCenterStatusUsecase
    implements UseCase<BaseOneResponse, ToggleMedicalCenterStatusParams> {
  final MedicalCenterRepository repository;

  ToggleMedicalCenterStatusUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(
    ToggleMedicalCenterStatusParams params,
  ) async {
    return await repository.toggleMedicalCenterStatus(
      medicalCenterId: params.medicalCenterId,
    );
  }
}
