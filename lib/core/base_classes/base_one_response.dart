import 'package:equatable/equatable.dart';

class BaseOneResponse extends Equatable {
  const BaseOneResponse({
    this.data,
    this.message,
    this.success,
    this.value,
    this.key,
    this.status,
    this.statusCode,
  });
  final String? value;
  final String? key;
  final dynamic data;
  final String? message;
  final bool? success;
  final bool? status;
  final int? statusCode;

  @override
  List<Object?> get props => [
    data,
    message,
    success,
    value,
    key,
    status,
    statusCode,
  ];

  factory BaseOneResponse.fromJson(Map<String, dynamic> json) =>
      BaseOneResponse(
        success: json['success'],
        message: json['message']?.toString(),
        status: json['status'],
        data: json['data'],
        value: json['value']?.toString(),
        key: json['key']?.toString(),
        statusCode: json['status_code'],
      );
}
