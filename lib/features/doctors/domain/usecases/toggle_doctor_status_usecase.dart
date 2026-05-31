import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

/// usecase
class ToggleDoctorStatusUsecase implements UseCase<BaseOneResponse, String> {
  final DoctorRepository repository;

  ToggleDoctorStatusUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(String id) async {
    return await repository.toggleDoctorStatus(id: id);
  }
}
