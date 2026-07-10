import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

class GetMedicalCenterDoctorsUsecase
    implements UseCase<BaseListResponse, int> {
  final DoctorRepository repository;

  GetMedicalCenterDoctorsUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(int id) async {
    return await repository.getMedicalCenterDoctors(id);
  }
}
