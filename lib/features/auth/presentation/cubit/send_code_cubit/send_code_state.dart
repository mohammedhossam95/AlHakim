part of 'send_code_cubit.dart';

abstract class SendCodeState extends Equatable {
  const SendCodeState();
  @override
  List<Object> get props => [];
}

class SendCodeInitial extends SendCodeState {}

class SendCodeIsLoading extends SendCodeState {}

class SendCodeLoaded extends SendCodeState {
  final BaseOneResponse response;

  const SendCodeLoaded({required this.response});
}

class SendCodeError extends SendCodeState {
  final String message;
  const SendCodeError(this.message);
}

