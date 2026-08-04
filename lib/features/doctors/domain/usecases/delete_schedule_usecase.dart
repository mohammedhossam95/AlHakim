import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:alhakim/features/doctors/domain/usecases/params/delete_schedule_params.dart';
import 'package:dartz/dartz.dart';

class DeleteScheduleUsecase
    implements UseCase<BaseOneResponse, DeleteScheduleParams> {
  final DoctorRepository repository;

  DeleteScheduleUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(DeleteScheduleParams params) {
    return repository.deleteSchedule(params: params);
  }
}
