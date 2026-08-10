part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginIsLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final BaseOneResponse response;
  final AuthenticateParams params;

  const LoginLoaded({required this.response, required this.params});

  @override
  List<Object> get props => [response, params];
}

class LoginError extends LoginState {
  final String message;
  final AuthenticateParams params;

  const LoginError({required this.message, required this.params});

  @override
  List<Object> get props => [message, params];
}
