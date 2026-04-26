part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterIsLoading extends RegisterState {
  final bool isLoading;

  const RegisterIsLoading({required this.isLoading});
}

class RegisterLoaded extends RegisterState {
  final BaseOneResponse response;
  final AuthParams params;

  const RegisterLoaded({required this.response, required this.params});
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);
}
