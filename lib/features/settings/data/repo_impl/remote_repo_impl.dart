import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '/core/params/change_password_params.dart';
import '/core/params/contact_us_param.dart';
import '/features/settings/data/data_source/setting_remote_data_source.dart';
import '/features/settings/data/model/support_phone_resp_model.dart';
import '/features/settings/domain/repo/setting_repo.dart';
import '../../../../core/utils/log_utils.dart' as log;

class SettingRemoteRepoImpl extends SettingRepo {
  final SettingRemoteDataSource settingRemoteDataSource;
  SettingRemoteRepoImpl({required this.settingRemoteDataSource});
  @override
  Future<Either<Failure, BaseOneResponse>> settingChangePassword(
    ChangePasswordParams params,
  ) async {
    try {
      final response = await settingRemoteDataSource.settingChangePassword(
        params,
      );
      return Right(BaseOneResponse(message: response.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> contactUsMethod(
    ContactUsParam param,
  ) async {
    try {
      final response = await settingRemoteDataSource.contactUsMethod(param);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportPhoneRespModel>> getSupportPhone() async {
    try {
      final response = await settingRemoteDataSource.getRemoteSupportPhone();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> getUserProfile(
    AuthParams params,
  ) async {
    try {
      final BaseOneResponse response = await settingRemoteDataSource
          .getUserProfile(params);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[getUserProfile] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> updateUserProfile(
    AuthParams params,
  ) async {
    try {
      final BaseOneResponse response = await settingRemoteDataSource
          .updateUserProfile(params);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[getUserProfile] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseListResponse>> getCommonQuestions() async {
    try {
      final BaseListResponse response = await settingRemoteDataSource
          .getCommonQuestions();
      return Right<Failure, BaseListResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[getcommon questions] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseListResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> getStaticPageContent(
    StaticPageType type,
  ) async {
    try {
      final BaseOneResponse response = await settingRemoteDataSource
          .getStaticPageContent(type);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[getStatic page content] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseListResponse>> getAppSetting() async {
    try {
      final BaseListResponse response = await settingRemoteDataSource
          .getAppSetting();
      return Right<Failure, BaseListResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[getApp Setting] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseListResponse>(error.toFailure());
    }
  }
}
