part of 'update_user_profile_cubit.dart';

abstract class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();
  @override
  List<Object> get props => [];
}

class UpdateUserProfileInitial extends UpdateUserProfileState {}

class UpdateUserProfileIsLoading extends UpdateUserProfileState {
  final bool isLoading;
  const UpdateUserProfileIsLoading({required this.isLoading});
}

class UpdateUserProfileLoaded extends UpdateUserProfileState {
  final BaseOneResponse response;

  const UpdateUserProfileLoaded({required this.response});
}

class UpdateUserProfileError extends UpdateUserProfileState {
  final String message;
  const UpdateUserProfileError(this.message);
}
