import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/log_utils.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/settings/data/model/app_setting_resp_model.dart';
import 'package:alhakim/features/settings/data/model/common_questions_resp_model.dart';
import 'package:alhakim/features/settings/data/model/hospital_emergency_resp_model.dart';
import 'package:alhakim/features/settings/data/model/static_page_content_resp_model.dart';
import 'package:alhakim/features/settings/domain/use_case/params/get_hospital_emergency_params.dart';
import 'package:dio/dio.dart';

import '/core/error/exceptions.dart';
import '/core/params/change_password_params.dart';
import '/core/params/contact_us_param.dart';
import '/features/settings/data/model/change_password_resp_model.dart';
import '/features/settings/data/model/contact_us_resp_model.dart';
import '/features/settings/data/model/support_phone_resp_model.dart';
import '/injection_container.dart';

abstract class SettingRemoteDataSource {
  Future<SettingChangePasswordRespModel> settingChangePassword(
    ChangePasswordParams params,
  );
  Future<SupportPhoneRespModel> getRemoteSupportPhone();
  Future<ContactUsRespModel> contactUsMethod(ContactUsParam params);
  Future<AuthRespModel> getUserProfile(AuthParams params);
  Future<UserModel> updateUserProfile(CompleteProfileParams params);
  Future<CommonQuestionsRespModel> getCommonQuestions();
  Future<StaticPageContentRespModel> getStaticPageContent(StaticPageType type);
  Future<AppSettingRespModel> getAppSetting();
  Future<HospitalEmergencyRespModel> getHospitalEmergencyNumbers(
    GetHospitalEmergencyParams params,
  );
}

class SettingRemoteDataSourceImpl extends SettingRemoteDataSource {
  @override
  Future<SettingChangePasswordRespModel> settingChangePassword(
    ChangePasswordParams params,
  ) async {
    String path = '/change-password';
    try {
      final response = await dioConsumer.post(path, body: params.toJson());
      return SettingChangePasswordRespModel.fromJson(response);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ContactUsRespModel> contactUsMethod(ContactUsParam params) async {
    String path = '/contactuses';
    try {
      final response = await dioConsumer.post(path, body: params.toJson());
      if (response['success'] == true) {
        return ContactUsRespModel.fromJson(response);
      } else {
        throw ServerException(message: response['message'] ?? 'Unknown error');
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SupportPhoneRespModel> getRemoteSupportPhone() async {
    try {
      String url = '/get_setting_by_key?key=phone';

      final response = await dioConsumer.get(url);
      if (response != null && response != []) {
        return getSupportPhoneFromJson(response);
      }

      throw ServerException(message: response);
    } on ServerException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AuthRespModel> getUserProfile(AuthParams params) async {
    try {
      final dynamic response = await dioConsumer.get(
        '/user/my/profile',
        // : '/get/user/profile/${params.userId}',
      );
      if (response['success'] == true) {
        return AuthRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUserProfile(CompleteProfileParams params) async {
    try {
      FormData formData = FormData();

      Log.d('formData: ${formData.fields.toString()}');

      // ===== 3. طلب الـ API =====
      final dynamic response = await dioConsumer.patch(
        '/profile',
        body: params.toJson(),
      );

      if (response['status'] == true) {
        return UserModel.fromJson(response['data']);
      }

      throw ServerException(message: response['message'] ?? 'Error occurred');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<CommonQuestionsRespModel> getCommonQuestions() async {
    try {
      final dynamic response = await dioConsumer.get('/faqs');
      if (response['success'] == true) {
        return CommonQuestionsRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  //----get staticPage end point
  String _getEndpoint(StaticPageType type) {
    //todo for localization cahnge ar  to en
    switch (type) {
      case StaticPageType.aboutUs:
        return '/get_setting_by_key?key=description_about_us_ar';
      case StaticPageType.privacy:
        return '/get_setting_by_key?key=privacy_policy_ar';
      case StaticPageType.conditions:
        return '/get_setting_by_key?key=conditions_ar';
      case StaticPageType.faq:
        return '/get_setting_by_key?key=frequently_asked_questions_ar';
    }
  }

  @override
  Future<StaticPageContentRespModel> getStaticPageContent(
    StaticPageType type,
  ) async {
    final path = _getEndpoint(type);
    try {
      final response = await dioConsumer.get(path);

      return StaticPageContentRespModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AppSettingRespModel> getAppSetting() async {
    try {
      final headers = await Constants.getAppConfigHeaders();
      final dynamic response = await dioConsumer.get(
        '/app-config',
        headers: headers,
      );
      if (response['status'] == true) {
        return AppSettingRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<HospitalEmergencyRespModel> getHospitalEmergencyNumbers(
    GetHospitalEmergencyParams params,
  ) async {
    try {
      final dynamic response = await dioConsumer.get(
        '/hospital-emergency-numbers',
        queryParameters: params.toQuery(),
      );
      if (response['status'] == true) {
        return HospitalEmergencyRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
