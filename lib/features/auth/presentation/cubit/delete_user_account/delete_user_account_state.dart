// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_user_account_cubit.dart';

abstract class DeleteUserAccountState extends Equatable {
  const DeleteUserAccountState();

  @override
  List<Object> get props => [];
}

class DeleteUserAccountInitial extends DeleteUserAccountState {}

class DeleteUserAccountLoading extends DeleteUserAccountState {
  final bool isLoading;
  const DeleteUserAccountLoading({required this.isLoading});
}

class DeleteUserAccountLoaded extends DeleteUserAccountState {
  final BaseOneResponse response;

  const DeleteUserAccountLoaded({required this.response});
}

class DeleteUserAccountError extends DeleteUserAccountState {
  final String message;
  const DeleteUserAccountError(this.message);
}
