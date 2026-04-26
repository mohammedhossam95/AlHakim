import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '/core/params/change_password_params.dart';
import '/core/params/contact_us_param.dart';
import '/features/settings/domain/entity/support_phone_response.dart';

abstract class SettingRepo {
  Future<Either<Failure, BaseOneResponse>> settingChangePassword(
    ChangePasswordParams params,
  );

  Future<Either<Failure, BaseOneResponse>> contactUsMethod(
    ContactUsParam param,
  );
  Future<Either<Failure, SupportPhoneResp>> getSupportPhone();
  Future<Either<Failure, BaseOneResponse>> getUserProfile(AuthParams params);
  Future<Either<Failure, BaseOneResponse>> updateUserProfile(AuthParams params);
  Future<Either<Failure, BaseListResponse>> getCommonQuestions();
  Future<Either<Failure, BaseOneResponse>> getStaticPageContent(
    StaticPageType type,
  );
  Future<Either<Failure, BaseListResponse>> getAppSetting();
}
