import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/home/domain/entity/ads_entity.dart';
import 'package:alhakim/features/home/domain/repo/home_repo.dart';
import 'package:dartz/dartz.dart';

class GetListAdsUsecase extends UseCase<BaseListResponse, AdsParams> {
  final HomeRepo repo;

  GetListAdsUsecase({required this.repo});
  @override
  Future<Either<Failure, BaseListResponse>> call(AdsParams params) async {
    return repo.getListAds(params);
  }
}
