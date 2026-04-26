import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/data/models/cities_resp_model.dart';
import 'package:alhakim/features/auth/data/models/countries_resp_model.dart';
import 'package:alhakim/features/auth/data/models/delete_user_account_resp_model.dart';
import 'package:alhakim/features/auth/data/models/get_setting_response_model.dart';
import 'package:alhakim/features/auth/data/models/send_code_resp_model.dart';
import 'package:alhakim/injection_container.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<AuthRespModel> login({required AuthParams params});
  Future<AuthRespModel> register({required AuthParams params});
  Future<AuthRespModel> verifyCode({required AuthParams params});
  Future<SendCodeRespModel> sendCode({required AuthParams params});
  Future<CountriesRespModel> getCountries();
  Future<CitiesRespModel> getAllCities({required AuthParams params});
  Future<SettingRespModel> getSetting();
  Future<DeleteUserAccountRespModel> deleteUserAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthRespModel> login({required AuthParams params}) async {
    try {
      FormData formData = FormData();

      if (params.phone != null) {
        formData.fields.add(MapEntry('phone_number', params.phone ?? ''));
      }
      if (params.countryCode != null) {
        formData.fields.add(MapEntry('country_code', params.countryCode ?? ''));
      }
      if (params.password != null) {
        formData.fields.add(MapEntry('password', params.password ?? ''));
      }
      final dynamic response = await dioConsumer.post(
        '/auth/login',
        formData: formData,
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
  Future<AuthRespModel> verifyCode({required AuthParams params}) async {
    try {
      FormData formData = FormData();

      if (params.otp != null) {
        formData.fields.add(MapEntry('otp', params.otp ?? ''));
      }
      if (params.phone != null) {
        formData.fields.add(MapEntry('phone', params.phone ?? ''));
      }

      final dynamic response = await dioConsumer.post(
        '/auth/verify/otp/phone',

        formData: formData,
      );
      if (response['success'] == true || response['success'] == 'true') {
        return AuthRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AuthRespModel> register({required AuthParams params}) async {
    try {
      FormData formData = FormData();

      if (params.name != null) {
        formData.fields.add(MapEntry('name', params.name ?? ''));
      }

      if (params.lastName != null) {
        formData.fields.add(MapEntry('last_name', params.lastName ?? ''));
      }
      if (params.phone != null) {
        formData.fields.add(MapEntry('phone', params.phone ?? ''));
      }
      if (params.countryCode != null) {
        formData.fields.add(MapEntry('country_code', params.countryCode ?? ''));
      }
      if (params.password != null) {
        formData.fields.add(MapEntry('password', params.password ?? ''));
      }
      if (params.passwordConfirmation != null) {
        formData.fields.add(
          MapEntry('password_confirmation', params.passwordConfirmation ?? ''),
        );
      }

      if (params.email != null) {
        formData.fields.add(MapEntry('email', params.email ?? ''));
      }
      if (params.fcmDeviceToken != null) {
        formData.fields.add(
          MapEntry('fcm_device_token', params.fcmDeviceToken ?? ''),
        );
      }

      final dynamic response = await dioConsumer.post(
        (params.registerType == 'withPhone')
            ? '/auth/signup/phone'
            : '/auth/signup/user',
        formData: formData,
      );
      if (response['success'] == true || response['success'] == 'true') {
        return AuthRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<SendCodeRespModel> sendCode({required AuthParams params}) async {
    try {
      FormData formData = FormData();

      if (params.phone != null) {
        formData.fields.add(MapEntry('phone_number', params.phone ?? ''));
      }
      if (params.countryCode != null) {
        formData.fields.add(MapEntry('country_code', params.countryCode ?? ''));
      }
      if (params.otpType != null) {
        formData.fields.add(MapEntry('sms_type', params.otpType ?? ''));
      }

      final dynamic response = await dioConsumer.post(
        '/clients/send_code',
        formData: formData,
      );
      if (response['success'] == true || response['success'] == 'true') {
        return SendCodeRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<CountriesRespModel> getCountries() async {
    try {
      final dynamic response = await dioConsumer.get(
        '/api/v1/get_list_governments',
      );
      if (response['status'] == 'success') {
        return CountriesRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<CitiesRespModel> getAllCities({required AuthParams params}) async {
    try {
      final dynamic response = await dioConsumer.get('/cities');
      if (response['success'] == true) {
        return CitiesRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<SettingRespModel> getSetting() async {
    try {
      final dynamic response = await dioConsumer.get('/settings/1');
      if (response['success'] == true) {
        return SettingRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<DeleteUserAccountRespModel> deleteUserAccount() async {
    try {
      final dynamic response = await dioConsumer.post(
        '/user/delete',
      ); //mallah make it post not delete
      if (response['status'] == 'success' || response['success'] == true) {
        return DeleteUserAccountRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
