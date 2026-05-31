part of 'complete_profile_cubit.dart';



sealed class CompleteProfileState extends Equatable {
  const CompleteProfileState();

  @override
  List<Object?> get props => [];
}

final class CompleteProfileInitial extends CompleteProfileState {}

final class CompleteProfileLoading extends CompleteProfileState {}

final class CompleteProfileSuccess extends CompleteProfileState {
  final AuthRespModel response;

  const CompleteProfileSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class CompleteProfileError extends CompleteProfileState {
  final String message;

  const CompleteProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
