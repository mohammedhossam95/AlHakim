import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:alhakim/features/doctors/domain/usecases/params/update_schedule_status_params.dart';
import 'package:dartz/dartz.dart';

class UpdateScheduleStatusUsecase
    implements UseCase<BaseOneResponse, UpdateScheduleStatusParams> {
  final DoctorRepository repository;

  UpdateScheduleStatusUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(
    UpdateScheduleStatusParams params,
  ) {
    return repository.updateScheduleStatus(params: params);
  }
}
