import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '/core/base_classes/api_error.dart';
import '../../injection_container.dart';
import '../error/exceptions.dart';
import '../utils/extension.dart';
import '../utils/log_utils.dart';
import '../utils/values/strings.dart';
import 'retry_interceptor.dart';
import 'status_code.dart';

abstract class ApiConstants {
  static const String dev = 'https://alhakim-eg.com/api/v1';
  static const String live = 'https://alhakim-eg.com/api/v1';
  static const String baseUrl = dev;
  static const String analyzeComplaint = '/complaints/analyze';
  static const String getNotifications = '/notifications';
  static const String markAllNotificationsAsRead = '/notifications/read-all';

  static String deleteDoctorSchedule({
    required String doctorId,
    required String scheduleId,
  }) => '/doctors/$doctorId/schedules/$scheduleId';

  static String closeClinic(String doctorId) =>
      '/doctors/$doctorId/close-clinic';

  static String updateDoctorScheduleStatus({
    required String doctorId,
    required String scheduleId,
  }) => '/doctors/$doctorId/schedules/$scheduleId/status';
}

abstract class DioConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<List<int>> getBytes(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<dynamic> post(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> patch(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> put(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  });

  void updateCountryIdParameter(int countryId);

  void updateLanguageCodeHeader();
  void updateDeviceTokenHeader();
  void updateDeviceTypeHeader();
}

class DioConsumerImpl implements DioConsumer {
  final Dio client;

  DioConsumerImpl({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final httpClient = HttpClient();
      // Drop idle keep-alive sockets before the server closes them, which
      // otherwise surfaces as intermittent DioExceptionType.connectionError.
      httpClient.idleTimeout = const Duration(seconds: 3);
      // client.findProxy = (uri) {
      // Proxy all request to localhost:8888.
      // Be aware, the proxy should went through you running device,
      // not the host platform.
      //   return 'PROXY https://doctor-app-production.up.railway.app';
      // };

      if (kDebugMode) {
        httpClient.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      }
      return httpClient;
    };

    Map<String, String> header = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.acceptLanguageHeader: sharedPreferences
          .getLanguageCode()
          .name,

      'device-lang': sharedPreferences.getLanguageCode().name,
      'device-token': '',
      'device-type': '',
    };

    client.options
      ..baseUrl = ApiConstants.baseUrl
      //..responseType = ResponseType.plain
      ..contentType = 'application/json'
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30)
      ..queryParameters = {
        // 'country_id': '${sharedPreferences.getCountryId() ?? 1}',
      }
      ..headers = header;
    // Retry transient connection failures before app/auth interceptors.
    client.interceptors.add(RetryInterceptor(client));
    client.interceptors.add(appInterceptors);
    if (kDebugMode) {
      client.interceptors.add(logInterceptor);
    }
  }

  /// Resolves the Bearer token (SecureStorage → SharedPreferences fallback)
  /// and returns it as per-request headers so concurrent calls cannot race
  /// on the shared [client.options.headers] map.
  Future<Map<String, dynamic>> _resolveAuthHeaders([
    Map<String, dynamic>? extraHeaders,
  ]) async {
    String? accessToken = await secureStorage.getAccessToken();

    // Fallback: restore from cached auth if SecureStorage was wiped unexpectedly.
    if (accessToken == null || accessToken.isEmpty) {
      final cachedToken = sharedPreferences.getAuth()?.token;
      if (cachedToken != null && cachedToken.isNotEmpty) {
        await secureStorage.saveAccessToken(cachedToken);
        accessToken = cachedToken;
      }
    }

    final headers = <String, dynamic>{...?extraHeaders};

    if (accessToken != null && accessToken.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    } else {
      headers.remove(HttpHeaders.authorizationHeader);
    }

    return headers;
  }

  Future<Options> _requestOptions({
    Map<String, dynamic>? headers,
    ResponseType? responseType,
  }) async {
    return Options(
      headers: await _resolveAuthHeaders(headers),
      responseType: responseType,
    );
  }

  @override
  void updateCountryIdParameter(int countryId) {
    // client.options.queryParameters['country_id'] = countryId.toString();
  }

  @override
  void updateLanguageCodeHeader() {
    client.options.headers[HttpHeaders.acceptLanguageHeader] = sharedPreferences
        .getLanguageCode()
        .name;
    client.options.headers['device-lang'] = sharedPreferences
        .getLanguageCode()
        .name;
  }

  @override
  void updateDeviceTokenHeader() {
    client.options.headers['device-token'] = tokenFCM;
  }

  @override
  void updateDeviceTypeHeader() {
    client.options.headers['device-type'] = Platform.isAndroid
        ? 'android'
        : 'ios';
  }

  @override
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Log.i('[GET][$path], params: ${queryParameters.toString()}');
      final response = await client.get(
        path,
        queryParameters: queryParameters,
        options: await _requestOptions(headers: headers),
      );
      Log.i('[GET][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<List<int>> getBytes(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      Log.i('[GET BYTES][$path], params: ${queryParameters.toString()}');
      final response = await client.get<List<int>>(
        path,
        queryParameters: queryParameters,
        options: await _requestOptions(
          headers: headers,
          responseType: ResponseType.bytes,
        ),
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(message: 'Empty response');
      }
      Log.i('[GET BYTES][$path], bytes: ${data.length}');
      return data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
      throw ServerException(message: error.message ?? 'Unknown Error');
    } catch (error) {
      if (error is ServerException ||
          error is InternetConnectionException ||
          error is UnauthorizedException) {
        rethrow;
      }
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future post(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Log.i(
        '[POST][$path], formData: ${formData?.toPrint}, body: ${body.toString()}, params: ${queryParameters.toString()}',
      );
      final response = await client.post(
        path,
        queryParameters: queryParameters,
        data: formData ?? body,
        options: await _requestOptions(),
      );
      Log.i('[POST][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future put(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Log.i(
        '[PUT][$path], formData: ${formData?.toPrint}, body: ${body.toString()}, params: ${queryParameters.toString()}',
      );
      final response = await client.put(
        path,
        queryParameters: queryParameters,
        data: formData ?? body,
        options: await _requestOptions(),
      );
      Log.i('[PUT][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    try {
      final response = await client.delete(
        path,
        queryParameters: queryParameters,
        data: data,
        options: await _requestOptions(),
      );
      Log.i('[DELETE][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  void _handleDioError(DioException error) {
    Log.e(
      '[DIO] type=${error.type} '
      'errorType=${error.error?.runtimeType} '
      'message=${error.message} '
      'path=${error.requestOptions.path}',
    );

    String getErrorMessage(dynamic data) {
      if (data is Map && data.containsKey('message')) {
        return data['message'].toString();
      }
      final strData = data?.toString() ?? "";
      if (strData.toLowerCase().contains('<!doctype html>') ||
          strData.toLowerCase().contains('<html>')) {
        return "Internal Server Error (302 Redirect)";
      }
      return strData.isNotEmpty ? strData : "Unknown Error";
    }

    if (error.response?.statusCode == StatusCode.unauthorized) {
      throw UnauthorizedException(
        message: getErrorMessage(error.response?.data),
      );
    }

    if (error.response?.statusCode == StatusCode.badRequest) {
      throw UnauthorizedException(
        message: getErrorMessage(error.response?.data),
      );
    }

    if (error.response?.statusCode == StatusCode.unProcessableContent) {
      if (error.response?.data is Map<String, dynamic>) {
        APIError apiError = APIError.fromJson(error.response?.data);
        String? message = apiError.getFirstError();
        throw ServerException(message: message);
      } else {
        throw ServerException(
          message: error.response?.data?.toString() ?? "Unprocessable Content",
        );
      }
    }

    if (error.response?.statusCode == StatusCode.updateRegisterApprovedUser) {
      throw UpdateRegisterApprovedUserException(
        message: getErrorMessage(error.response?.data),
      );
    }
    if (error.type == DioExceptionType.unknown) {
      throw ServerException(message: "Unknown");
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    }

    throw ServerException(message: getErrorMessage(error.response?.data));
  }

  @override
  Future<dynamic> patch(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Log.i(
        '[PATCH][$path], formData: ${formData?.toPrint}, body: ${body.toString()}, params: ${queryParameters.toString()}',
      );
      final response = await client.patch(
        path,
        queryParameters: queryParameters,
        data: formData ?? body,
        options: await _requestOptions(),
      );
      Log.i('[PATCH][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }
}
