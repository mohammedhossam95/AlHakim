part of 'get_user_profile_cubit.dart';

abstract class GetUserProfileState extends Equatable {
  const GetUserProfileState();
  @override
  List<Object> get props => [];
}

class GetUserProfileInitial extends GetUserProfileState {}

class GetUserProfileIsLoading extends GetUserProfileState {}

class GetUserProfileLoaded extends GetUserProfileState {
  final BaseOneResponse response;

  const GetUserProfileLoaded({required this.response});
}

class GetUserProfileError extends GetUserProfileState {
  final String message;
  const GetUserProfileError(this.message);
}
