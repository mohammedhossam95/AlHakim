import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/data/models/cities_resp_model.dart';
import 'package:alhakim/features/auth/data/models/countries_resp_model.dart';
import 'package:alhakim/features/auth/data/models/delete_user_account_resp_model.dart';
import 'package:alhakim/features/auth/data/models/get_setting_response_model.dart';
import 'package:alhakim/features/auth/data/models/send_code_resp_model.dart';
import 'package:alhakim/injection_container.dart';

abstract class AuthRemoteDataSource {
  Future<AuthRespModel> login({required AuthParams params});
  Future<AuthRespModel> register({required AuthParams params});
  Future<AuthRespModel> verifyCode({required AuthParams params});
  Future<SendCodeRespModel> sendCode({required AuthParams params});
  Future<void> logout({required bool isTeacher});
  Future<CountriesRespModel> getCountries();
  Future<CitiesRespModel> getAllCities({required AuthParams params});
  Future<SettingRespModel> getSetting();
  Future<DeleteUserAccountRespModel> deleteUserAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthRespModel> login({required AuthParams params}) async {
    try {
      final dynamic response = await dioConsumer.post(
        "endpoint",
        // body: params.toLoginJson(),
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
      final dynamic response = await dioConsumer.post(
        '/auth/verify-otp',
        // body: params.toVerifyOtpJson(),
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
  Future<SendCodeRespModel> sendCode({required AuthParams params}) async {
    try {
      final dynamic response = await dioConsumer.post(
        '/auth/send-otp',
        // body: params.toSendOtpJson(),
      );
      if (response['success'] == true || response['status'] == 'success') {
        return SendCodeRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> logout({required bool isTeacher}) async {
    try {
      final endpoint = isTeacher ? '/instructor/logout' : '/auth/logout';
      await dioConsumer.post(endpoint, body: {});
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
