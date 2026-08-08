import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:alhakim/features/doctors/domain/usecases/params/close_clinic_params.dart';
import 'package:dartz/dartz.dart';

class CloseClinicUsecase
    implements UseCase<BaseOneResponse, CloseClinicParams> {
  final DoctorRepository repository;

  CloseClinicUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(CloseClinicParams params) {
    return repository.closeClinic(params: params);
  }
}
