import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/specialities/domain/usecases/params/get_specialty_doctors_params.dart';
import 'package:dartz/dartz.dart';

abstract class SpecialtyRepository {
  Future<Either<Failure, BaseListResponse>> getSpecialties();
  Future<Either<Failure, BaseListResponse>> getSpecialtyDoctors(
    GetSpecialtyDoctorsParams params,
  );
}
