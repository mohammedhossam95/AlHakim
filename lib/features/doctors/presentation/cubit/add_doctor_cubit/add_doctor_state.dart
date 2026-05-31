part of 'add_doctor_cubit.dart';

sealed class AddDoctorState extends Equatable {
  const AddDoctorState();

  @override
  List<Object> get props => [];
}

final class AddDoctorInitial extends AddDoctorState {}

final class AddDoctorLoading extends AddDoctorState {}

final class AddDoctorSuccess extends AddDoctorState {
  final BaseOneResponse response;

  const AddDoctorSuccess({required this.response});
}

final class AddDoctorError extends AddDoctorState {
  final String message;

  const AddDoctorError({required this.message});
}
