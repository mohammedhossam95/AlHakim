import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/core/utils/enums.dart';
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
  Future<SendOtpRespModel> sendOtp(AuthParams params);
  Future<SendOtpRespModel> resendOtp(AuthParams params);
  Future<void> logout();
  Future<CountriesRespModel> getCountries();
  Future<CitiesRespModel> getAllCities({required AuthParams params});
  Future<SettingRespModel> getSetting();
  Future<DeleteUserAccountRespModel> deleteUserAccount();
  Future<AuthRespModel> completeProfile({
    required CompleteProfileParams params,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthRespModel> login({required AuthParams params}) async {
    try {
      final endPoint = "/auth/login";
      final dynamic response = await dioConsumer.post(
        endPoint,
        body: params.toJson(),
      );
      final isSuccess =
          response['success'] == true || response['status'] == 'success';
      if (isSuccess) {
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
      final FormData formData = FormData();
      if (params.countryCode != null) {
        formData.fields.add(MapEntry('country_code', params.countryCode!));
      }
      if (params.phoneNumber != null) {
        formData.fields.add(MapEntry('phone_number', params.phoneNumber!));
      }
      if (params.otp != null) {
        formData.fields.add(MapEntry('otp', params.otp!));
      }
      if (params.phoneNumber != null) {
        formData.fields.add(MapEntry('secretary_phone', params.phoneNumber!));
      }
      if (params.countryCode != null) {
        formData.fields.add(
          MapEntry('secretary_country_code', params.countryCode!),
        );
      }
      if (params.firebaseToken != null) {
        formData.fields.add(MapEntry('device_token', params.firebaseToken!));
      }

      // final isDoctor = params.userType == UserType.doctor;
      final endpoint = '/auth/verify-otp';

      final response = await dioConsumer.post(endpoint, formData: formData);

      if (response['status'] == true) {
        final authResponse = AuthRespModel.fromJson(response);

        // await _saveAuthResponse(authResponse);

        return authResponse;
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> _saveAuthResponse(AuthRespModel response) async {
  //   if (response.data != null && response.data is AuthModel) {
  //     final auth = response.data as AuthModel;

  //     sharedPreferences.saveAuth(auth);

  //     if (auth.token != null && auth.token!.isNotEmpty) {
  //       await secureStorage.saveAccessToken(auth.token!);
  //     }
  //   }
  // }
  @override
  Future<AuthRespModel> completeProfile({
    required CompleteProfileParams params,
  }) async {
    try {
      final response = await dioConsumer.post(
        '/auth/complete-profile',
        formData: FormData.fromMap(params.toJson()),
      );

      if (response['status'] == true) {
        return AuthRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SendOtpRespModel> resendOtp(AuthParams params) async {
    try {
      final FormData? formData =
          params.countryCode != null && params.phoneNumber != null
          ? FormData.fromMap({
              'country_code': params.countryCode,
              'phone_number': params.phoneNumber,
              'secretary_phone': params.phoneNumber,
              'secretary_country_code': params.countryCode,
            })
          : null;
      final response = await dioConsumer.post(
        '/auth/resend-otp',
        formData: formData,
      );

      if (response['status'] == true) {
        return SendOtpRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final endpoint = '/auth/logout';

      final response = await dioConsumer.post(endpoint);

      if (response['status'] == true) {
        await secureStorage.clearAll();

        await sharedPreferences.clearAll();

        return;
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AuthRespModel> register({required AuthParams params}) async {
    try {
      final dynamic response = await dioConsumer.post(
        '/auth/register',
        // body: params.toRegisterJson(),
      );
      if (response['success'] == true || response['status'] == 'success') {
        return AuthRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<SendOtpRespModel> sendOtp(AuthParams params) async {
    try {
      final endpoint = '/auth/send-otp';
      final FormData? formData =
          params.countryCode != null && params.phoneNumber != null
          ? FormData.fromMap({
              'country_code': params.countryCode,
              'phone_number': params.phoneNumber,
              'secretary_phone': params.secretaryPhone,
              'secretary_country_code': params.countryCode,
            })
          : null;
      final response = await dioConsumer.post(endpoint, formData: formData);

      if (response['status'] == true) {
        return SendOtpRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
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
      final dynamic response = await dioConsumer.delete('/api/v1/user/delete');
      if (response['status'] == 'success') {
        return DeleteUserAccountRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
