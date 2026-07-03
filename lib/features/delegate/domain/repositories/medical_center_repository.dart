import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/add_medical_center_params.dart';
import 'package:dartz/dartz.dart';

abstract class MedicalCenterRepository {
  Future<Either<Failure, BaseListResponse>> getMedicalCenters();
  Future<Either<Failure, BaseOneResponse>> addMedicalCenter({
    required AddMedicalCenterParams params,
  });
  Future<Either<Failure, BaseOneResponse>> updateMedicalCenter({
    required AddMedicalCenterParams params,
  });
  Future<Either<Failure, BaseOneResponse>> deleteMedicalCenter({
    required String medicalCenterId,
  });
  Future<Either<Failure, BaseOneResponse>> toggleMedicalCenterStatus({
    required String medicalCenterId,
  });
}
