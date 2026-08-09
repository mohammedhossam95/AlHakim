part of 'forgot_password_cubit.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final BaseOneResponse response;
  final AuthParams resetParams;
  final String? nextStep;

  const ForgotPasswordSuccess({
    required this.response,
    required this.resetParams,
    this.nextStep,
  });

  @override
  List<Object?> get props => [response, resetParams, nextStep];
}

final class ForgotPasswordError extends ForgotPasswordState {
  final String message;

  const ForgotPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}
