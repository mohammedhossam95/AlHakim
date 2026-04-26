import 'package:alhakim/features/home/data/models/get_ads_resp_model.dart';
import 'package:alhakim/features/home/data/models/home_banners_resp_model.dart';
import 'package:alhakim/features/home/domain/entity/ads_entity.dart';

import '/core/error/exceptions.dart';
import '/injection_container.dart';

abstract class HomeRemoteDatasource {
  Future<HomeBannersRespModel> getHomeBanners();
  Future<AllAdsRespModel> getListAds(AdsParams params);
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  @override
  Future<HomeBannersRespModel> getHomeBanners() async {
    try {
      final dynamic response = await dioConsumer.get('/get/list/banners');

      if (response['success'] == true || response['status'] == 200) {
        return HomeBannersRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AllAdsRespModel> getListAds(AdsParams params) async {
    try {
      final queryParams = {
        if (params.id == null) "page": params.currentPage,
        if (params.search != null && params.search!.isNotEmpty)
          "search": params.search,
      };

      final response = await dioConsumer.get(
        (params.id != null) ? '/get/user/ads/${params.id}' : '/get_list_ads',
        queryParameters: queryParams,
      );

      if (response['success'] == true || response['status'] == 200) {
        return AllAdsRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
