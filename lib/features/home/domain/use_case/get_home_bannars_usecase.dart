import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/home/domain/repo/home_repo.dart';
import 'package:dartz/dartz.dart';

class GetHomeBannarsUsecase extends UseCase<BaseListResponse, NoParams> {
  final HomeRepo repo;

  GetHomeBannarsUsecase({required this.repo});
  @override
  Future<Either<Failure, BaseListResponse>> call(NoParams params) async {
    return repo.getHomeBannars();
  }
}
