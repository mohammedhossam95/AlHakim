import 'package:alhakim/features/home/data/models/analyze_complaint_request.dart';
import 'package:alhakim/features/home/data/models/analyze_complaint_response_model.dart';
import 'package:alhakim/features/home/data/models/get_ads_resp_model.dart';
import 'package:alhakim/features/home/domain/entity/ads_entity.dart';

import '/core/api/dio_consumer.dart';
import '/core/error/exceptions.dart';
import '/injection_container.dart';

abstract class HomeRemoteDatasource {
  Future<AllAdsRespModel> getListAds(AdsParams params);
  Future<AnalyzeComplaintResponse> analyzeComplaint(
    AnalyzeComplaintRequest request,
  );
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
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

  @override
  Future<AnalyzeComplaintResponse> analyzeComplaint(
    AnalyzeComplaintRequest request,
  ) async {
    try {
      final response = await dioConsumer.post(
        ApiConstants.analyzeComplaint,
        formData: request.toFormData(),
      );

      if (response['status'] == true || response['success'] == true) {
        return AnalyzeComplaintResponse.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
