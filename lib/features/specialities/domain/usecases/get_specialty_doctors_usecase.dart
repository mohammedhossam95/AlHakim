import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/specialities/domain/repositories/specialty_repository.dart';
import 'package:alhakim/features/specialities/domain/usecases/params/get_specialty_doctors_params.dart';
import 'package:dartz/dartz.dart';

class GetSpecialtyDoctorsUsecase
    implements UseCase<BaseListResponse, GetSpecialtyDoctorsParams> {
  final SpecialtyRepository repository;

  GetSpecialtyDoctorsUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(
    GetSpecialtyDoctorsParams params,
  ) async {
    return await repository.getSpecialtyDoctors(params);
  }
}
