import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/delegate/domain/repositories/medical_center_repository.dart';
import 'package:dartz/dartz.dart';

class GetMedicalCentersUsecase implements UseCase<BaseListResponse, NoParams> {
  final MedicalCenterRepository repository;

  GetMedicalCentersUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(NoParams params) async {
    return await repository.getMedicalCenters();
  }
}
