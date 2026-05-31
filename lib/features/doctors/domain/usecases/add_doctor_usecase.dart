import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/add_doctor_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

class AddDoctorUsecase implements UseCase<BaseOneResponse, AddDoctorParams> {
  final DoctorRepository repository;

  AddDoctorUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(AddDoctorParams params) async {
    return await repository.addDoctor(params);
  }
}
