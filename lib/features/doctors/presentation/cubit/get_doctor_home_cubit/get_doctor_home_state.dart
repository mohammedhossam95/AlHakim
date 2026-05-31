part of 'get_doctor_home_cubit.dart';

sealed class GetDoctorHomeState extends Equatable {
  const GetDoctorHomeState();

  @override
  List<Object?> get props => [];
}

final class GetDoctorHomeInitial extends GetDoctorHomeState {}

final class GetDoctorHomeLoading extends GetDoctorHomeState {}

final class GetDoctorHomeSuccess extends GetDoctorHomeState {
  final BaseOneResponse response;

  const GetDoctorHomeSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetDoctorHomeError extends GetDoctorHomeState {
  final String message;

  const GetDoctorHomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
