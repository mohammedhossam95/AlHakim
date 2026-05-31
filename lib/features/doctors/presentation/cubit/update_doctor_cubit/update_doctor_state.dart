part of 'update_doctor_cubit.dart';

sealed class UpdateDoctorState extends Equatable {
  const UpdateDoctorState();

  @override
  List<Object> get props => [];
}

final class UpdateDoctorInitial extends UpdateDoctorState {}

final class UpdateDoctorLoading extends UpdateDoctorState {}

final class UpdateDoctorSuccess extends UpdateDoctorState {
  final BaseOneResponse response;

  const UpdateDoctorSuccess({required this.response});
}

final class UpdateDoctorError extends UpdateDoctorState {
  final String message;

  const UpdateDoctorError({required this.message});
}
