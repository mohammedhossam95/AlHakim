part of 'toggel_doctor_status_cubit.dart';

sealed class ToggelDoctorStatusState extends Equatable {
  const ToggelDoctorStatusState();

  @override
  List<Object> get props => [];
}

final class ToggelDoctorStatusInitial extends ToggelDoctorStatusState {}

final class ToggleDoctorStatusLoading extends ToggelDoctorStatusState {}

final class ToggleDoctorStatusSuccess extends ToggelDoctorStatusState {
  final BaseOneResponse response;

  const ToggleDoctorStatusSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

final class ToggleDoctorStatusError extends ToggelDoctorStatusState {
  final String message;

  const ToggleDoctorStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
