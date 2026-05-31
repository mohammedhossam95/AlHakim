part of 'resend_otp_cubit.dart';

sealed class ResendOtpState extends Equatable {
  const ResendOtpState();

  @override
  List<Object> get props => [];
}

class ResendOtpInitial extends ResendOtpState {}

class ResendOtpLoading extends ResendOtpState {}

class ResendOtpSuccess extends ResendOtpState {
  final BaseOneResponse response;

  const ResendOtpSuccess({required this.response});
}

class ResendOtpError extends ResendOtpState {
  final String message;

  const ResendOtpError({required this.message});
}
