part of 'change_password_cubit.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitialState extends ChangePasswordState {}
class ChangePasswordLoadingState extends ChangePasswordState {}
class ChangePasswordSuccessState extends ChangePasswordState {
  final BaseOneResponse resp;
  const ChangePasswordSuccessState({required this.resp});
}
class ChangePasswordErrorState extends ChangePasswordState {
  final String message;
  const ChangePasswordErrorState({required this.message});
  @override
  List<Object> get props => [message];
}


