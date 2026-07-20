import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/home/data/data_source/home_remote_datasource.dart';
import 'package:alhakim/features/home/data/models/analyze_complaint_request.dart';
import 'package:alhakim/features/home/data/models/analyze_complaint_response_model.dart';
import 'package:alhakim/features/home/domain/entity/ads_entity.dart';
import 'package:alhakim/features/home/domain/repo/home_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/utils/log_utils.dart';

class HomeRepoImpl extends HomeRepo {
  final HomeRemoteDatasource remote;

  HomeRepoImpl({required this.remote});


  @override
  Future<Either<Failure, BaseListResponse>> getListAds(AdsParams params) async {
    try {
      final result = await remote.getListAds(params);
      return Right<Failure, BaseListResponse>(result);
    } on AppException catch (error) {
      Log.e(
        '[get all Ads][${error.runtimeType.toString()}]--- ${error.message}',
      );
      return Left<Failure, BaseListResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, AnalyzeComplaintResponse>> analyzeComplaint(
    AnalyzeComplaintRequest request,
  ) async {
    try {
      final result = await remote.analyzeComplaint(request);
      return Right<Failure, AnalyzeComplaintResponse>(result);
    } on AppException catch (error) {
      Log.e(
        '[analyzeComplaint][${error.runtimeType.toString()}]--- ${error.message}',
      );
      return Left<Failure, AnalyzeComplaintResponse>(error.toFailure());
    }
  }
}
