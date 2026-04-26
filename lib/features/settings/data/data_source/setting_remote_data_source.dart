import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/core/utils/log_utils.dart';
import 'package:alhakim/features/settings/data/model/app_setting_resp_model.dart';
import 'package:alhakim/features/settings/data/model/common_questions_resp_model.dart';
import 'package:alhakim/features/settings/data/model/static_page_content_resp_model.dart';
import 'package:alhakim/features/settings/data/model/user_profile_resp_model.dart';
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
  Future<UserProfileRespModel> getUserProfile(AuthParams params);
  Future<UserProfileRespModel> updateUserProfile(AuthParams params);
  Future<CommonQuestionsRespModel> getCommonQuestions();
  Future<StaticPageContentRespModel> getStaticPageContent(StaticPageType type);
  Future<AppSettingRespModel> getAppSetting();
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
  Future<UserProfileRespModel> getUserProfile(AuthParams params) async {
    try {
      final dynamic response = await dioConsumer.get(
        (params.isMyProfile == true)
            ? '/user/my/profile'
            : '/get/user/profile/${params.userId}',
      );
      if (response['success'] == true) {
        return UserProfileRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<UserProfileRespModel> updateUserProfile(AuthParams params) async {
    try {
      FormData formData = FormData();

      // ===== 1. الحقول النصية =====

      if (params.name != null) {
        formData.fields.add(MapEntry('name', params.name!));
      }
      if (params.lastName != null) {
        formData.fields.add(MapEntry('last_name', params.lastName!));
      }
      if (params.phone != null) {
        formData.fields.add(MapEntry('phone', params.phone!));
      }
      if (params.countryCode != null) {
        formData.fields.add(MapEntry('country_code', params.countryCode!));
      }
      if (params.whatsapp != null) {
        formData.fields.add(MapEntry('whatsapp', params.whatsapp!));
      }
      if (params.email != null) {
        formData.fields.add(MapEntry('email', params.email!));
      }
      if (params.bio != null) {
        formData.fields.add(MapEntry('bio', params.bio!));
      }

      // ===== 2. الصورة =====
      if (params.imageUrl != null && params.imageUrl!.isNotEmpty) {
        bool isLocalFile = !params.imageUrl!.startsWith('http');
        if (isLocalFile) {
          formData.files.add(
            MapEntry(
              'image',
              await MultipartFile.fromFile(
                params.imageUrl!,
                filename: params.imageUrl!.split('/').last,
              ),
            ),
          );
        }
      }
      Log.d('formData: ${formData.fields.toString()}');

      // ===== 3. طلب الـ API =====
      final dynamic response = await dioConsumer.post(
        '/user/update/profile',
        formData: formData,
      );

      // ===== 4. التحقق من النجاح =====
      if (response['success'] == true) {
        return UserProfileRespModel.fromJson(response);
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
      final dynamic response = await dioConsumer.get('/get_settings');
      if (response['success'] == true) {
        return AppSettingRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
