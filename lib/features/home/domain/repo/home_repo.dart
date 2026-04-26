import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/home/domain/entity/ads_entity.dart';
import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';

abstract class HomeRepo {
  Future<Either<Failure, BaseListResponse>> getHomeBannars();
  Future<Either<Failure, BaseListResponse>> getListAds(AdsParams params);
}
