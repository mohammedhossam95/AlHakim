import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

class GetDoctorHomeUsecase implements UseCase<BaseOneResponse, int> {
  final DoctorRepository repository;

  GetDoctorHomeUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(int id) {
    return repository.getDoctorHome(id);
  }
}
