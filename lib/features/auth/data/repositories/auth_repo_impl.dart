import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/utils/log_utils.dart';
import 'package:dartz/dartz.dart';

import '/core/params/auth_params.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/enums.dart';
import '../../../../injection_container.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/usecases/save_session_usecase.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_resp_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl({required this.remote});

  /// Impl
  @override
  Future<Either<Failure, SessionStatus>> getUserSession({
    required NoParams params,
  }) async {
    try {
      SessionStatus userType = sharedPreferences.getSessionStatus();
      return Right<Failure, SessionStatus>(userType);
    } on AppException catch (error) {
      Log.e(
        '[Get Session][${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, SessionStatus>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveUserSession({
    required SessionStatusParams params,
  }) async {
    try {
      bool result = await sharedPreferences.saveSessionStatus(params.status);
      return Right(result);
    } on AppException catch (error) {
      Log.e(
        '[Save Session] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, bool>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> loginRepo(AuthParams params) async {
    try {
      final BaseOneResponse response = await remote.login(params: params);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      Log.e(
        '[loginRepo] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> verifyCode(AuthParams params) async {
    try {
      final BaseOneResponse response = await remote.verifyCode(params: params);
      if (response.data != null && response.data is UserModel) {
        final UserModel user = response.data as UserModel;
        if (user.id != null) {
          sharedPreferences.saveUserId(user.id!);
        }
        sharedPreferences.saveUser(user);
        if (user.token != null) {
          secureStorage.saveAccessToken(user.token!);
        }
      }

      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      Log.e(
        '[verifyCode] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> register(AuthParams params) async {
    try {
      final BaseOneResponse response = await remote.register(params: params);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      Log.e(
        '[register] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> sendCode(AuthParams params) async {
    try {
      final BaseOneResponse response = await remote.sendCode(params: params);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      Log.e(
        '[sendCode] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseListResponse>> getCountries() async {
    try {
      final BaseListResponse response = await remote.getCountries();
      return Right<Failure, BaseListResponse>(response);
    } on AppException catch (error) {
      Log.e(
        '[getCountries] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseListResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseListResponse>> getAllCities(
    AuthParams params,
  ) async {
    try {
      final BaseListResponse response = await remote.getAllCities(
        params: params,
      );
      return Right<Failure, BaseListResponse>(response);
    } on AppException catch (error) {
      Log.e(
        '[getAllCities] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseListResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> getSetting() async {
    try {
      final response = await remote.getSetting();
      sharedPreferences.saveSettings(response.data);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      Log.e(
        '[getSetting] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> deleteUserAccount() async {
    try {
      final response = await remote.deleteUserAccount();
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      Log.e(
        '[getSetting] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }
}
