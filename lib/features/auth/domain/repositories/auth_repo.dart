import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:dartz/dartz.dart';

import '/core/params/auth_params.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/enums.dart';
import '../usecases/save_session_usecase.dart';
import '../usecases/save_user_type_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, SessionStatus>> getUserSession({
    required NoParams params,
  });
  Future<Either<Failure, bool>> saveUserSession({
    required SessionStatusParams params,
  });
  Future<Either<Failure, BaseOneResponse>> resendOtp(AuthParams params);

  Future<Either<Failure, UserType>> getUserType({required NoParams params});
  Future<Either<Failure, bool>> saveUserType({required UserTypeParams params});

  Future<Either<Failure, AuthRespModel>> completeProfile({
    required CompleteProfileParams params,
  });
  Future<Either<Failure, BaseOneResponse>> loginRepo(AuthParams params);
  Future<Either<Failure, BaseOneResponse>> verifyCode(AuthParams params);
  Future<Either<Failure, BaseOneResponse>> checkPhoneVerified(AuthParams params);
  Future<Either<Failure, BaseOneResponse>> checkAccount(AuthParams params);
  Future<Either<Failure, BaseOneResponse>> register(AuthParams params);
  Future<Either<Failure, BaseOneResponse>> sendCode(AuthParams params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, BaseListResponse>> getCountries();
  Future<Either<Failure, BaseListResponse>> getAllCities(AuthParams params);

  Future<Either<Failure, BaseOneResponse>> getSetting();
  Future<Either<Failure, BaseOneResponse>> deleteUserAccount();
}
