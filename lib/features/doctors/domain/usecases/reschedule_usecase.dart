import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/reschedule_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

class RescheduleUsecase implements UseCase<BaseOneResponse, RescheduleParams> {
  final DoctorRepository repository;

  RescheduleUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(RescheduleParams params) {
    return repository.reschedule(params: params);
  }
}
