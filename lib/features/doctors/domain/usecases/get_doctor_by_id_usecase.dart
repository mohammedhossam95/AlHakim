import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

class GetDoctorByIdUsecase implements UseCase<DoctorEntity, String> {
  final DoctorRepository repository;

  GetDoctorByIdUsecase({required this.repository});

  @override
  Future<Either<Failure, DoctorEntity>> call(String doctorId) {
    return repository.getDoctorById(doctorId);
  }
}
