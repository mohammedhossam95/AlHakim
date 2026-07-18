import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:alhakim/features/doctors/domain/usecases/params/search_doctors_params.dart';
import 'package:dartz/dartz.dart';

class SearchDoctorsUsecase
    implements UseCase<BaseListResponse, SearchDoctorsParams> {
  final DoctorRepository repository;

  SearchDoctorsUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(
    SearchDoctorsParams params,
  ) async {
    return await repository.getDoctors(
      search: params.search,
      perPage: params.perPage,
    );
  }
}
