import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/delegate/domain/repositories/medical_center_repository.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/delete_medical_center_params.dart';
import 'package:dartz/dartz.dart';

class DeleteMedicalCenterUsecase
    implements UseCase<BaseOneResponse, DeleteMedicalCenterParams> {
  final MedicalCenterRepository repository;

  DeleteMedicalCenterUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(
    DeleteMedicalCenterParams params,
  ) async {
    return await repository.deleteMedicalCenter(
      medicalCenterId: params.medicalCenterId,
    );
  }
}
