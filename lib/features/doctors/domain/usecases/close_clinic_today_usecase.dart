import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

class CloseClinicTodayUsecase implements UseCase<BaseOneResponse, String> {
  final DoctorRepository repository;

  CloseClinicTodayUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(String params) {
    return repository.closeClinicToday(doctorId: params);
  }
}
