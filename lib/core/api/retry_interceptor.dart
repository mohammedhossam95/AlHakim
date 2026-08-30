import 'dart:io';

import 'package:dio/dio.dart';

import '../utils/log_utils.dart';

/// Retries transient connection failures caused by stale keep-alive sockets
/// or brief network blips. Does not retry HTTP error responses (4xx/5xx).
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio);

  final Dio _dio;

  static const String _retryCountKey = 'retry_count';
  static const int _maxRetries = 2;
  static const List<Duration> _backoff = [
    Duration(milliseconds: 500),
    Duration(milliseconds: 1500),
  ];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final attempt = (err.requestOptions.extra[_retryCountKey] as int?) ?? 0;
    if (attempt >= _maxRetries) {
      return handler.next(err);
    }

    final nextAttempt = attempt + 1;
    err.requestOptions.extra[_retryCountKey] = nextAttempt;

    Log.i(
      '[RETRY] attempt $nextAttempt/$_maxRetries '
      'path=${err.requestOptions.path} type=${err.type}',
    );

    await Future<void>.delayed(_backoff[attempt]);

    try {
      final options = err.requestOptions;
      if (options.data is FormData) {
        options.data = (options.data as FormData).clone();
      }

      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    } catch (e) {
      return handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  bool _shouldRetry(DioException err) {
    // Never retry when the server already responded.
    if (err.response?.statusCode != null) {
      return false;
    }

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      return true;
    }

    if (err.type == DioExceptionType.unknown) {
      final Object? error = err.error;
      if (error is SocketException) {
        return true;
      }
      if (error is HttpException) {
        final message = error.message;
        return message.contains(
              'Connection closed before full header was received',
            ) ||
            message.contains('Connection reset');
      }
    }

    return false;
  }
}
