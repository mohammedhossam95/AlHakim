import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/appoinments_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:dartz/dartz.dart';

class GetDoctorAppoinmentsForDayUsecase
    implements UseCase<BaseListResponse, AppoinmentsParams> {
  final DoctorRepository repository;

  GetDoctorAppoinmentsForDayUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(AppoinmentsParams params) {
    return repository.getDoctorAppoinmentsForDay(params: params);
  }
}
