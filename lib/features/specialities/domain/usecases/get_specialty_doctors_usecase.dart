import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/specialities/domain/repositories/specialty_repository.dart';
import 'package:dartz/dartz.dart';

class GetSpecialtyDoctorsUsecase implements UseCase<BaseListResponse, String> {
  final SpecialtyRepository repository;

  GetSpecialtyDoctorsUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(String id) async {
    return await repository.getSpecialtyDoctors(id);
  }
}
