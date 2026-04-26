// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class GetSettingUseCase extends UseCase<BaseOneResponse, NoParams> {
  final AuthRepository repository;
  GetSettingUseCase({required this.repository});
  @override
  Future<Either<Failure, BaseOneResponse>> call(NoParams params) async {
    return await repository.getSetting();
  }
}
