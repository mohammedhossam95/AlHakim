import 'package:equatable/equatable.dart';

class SendOtpEntity extends Equatable {
  final String? otp;
  final String? nextStep;
  final String? token;

  const SendOtpEntity({this.otp, this.nextStep, this.token});

  @override
  List<Object?> get props => [otp, nextStep, token];
}
