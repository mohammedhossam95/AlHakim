part of 'verify_code_cubit.dart';

abstract class VerifyCodeState extends Equatable {
  const VerifyCodeState();
  @override
  List<Object> get props => [];
}

class VerifyCodeInitial extends VerifyCodeState {}

class VerifyCodeIsLoading extends VerifyCodeState {}

class VerifyCodeLoaded extends VerifyCodeState {
  final BaseOneResponse response;

  const VerifyCodeLoaded({required this.response});
}

class VerifyCodeError extends VerifyCodeState {
  final String message;
  const VerifyCodeError(this.message);
}

