import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/auth/domain/entities/send_otp_entity.dart';

class SendOtpRespModel extends BaseOneResponse {
  const SendOtpRespModel({super.status, super.message, super.data});

  factory SendOtpRespModel.fromJson(Map<String, dynamic> json) {
    return SendOtpRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? SendOtpModel.fromJson(json['data']) : null,
    );
  }
}

class SendOtpModel extends SendOtpEntity {
  const SendOtpModel({super.otp, super.nextStep, super.token});

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel(
      otp: json['otp'],
      nextStep: json['next_step'],
      token: json['token'],
    );
  }
}
