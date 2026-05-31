part of 'delete_doctor_cubit.dart';

sealed class DeleteDoctorState
    extends Equatable {
  const DeleteDoctorState();

  @override
  List<Object> get props => [];
}

final class DeleteDoctorInitial
    extends DeleteDoctorState {}

final class DeleteDoctorLoading
    extends DeleteDoctorState {}

final class DeleteDoctorSuccess
    extends DeleteDoctorState {
  final BaseOneResponse response;

  const DeleteDoctorSuccess({
    required this.response,
  });
}

final class DeleteDoctorError
    extends DeleteDoctorState {
  final String message;

  const DeleteDoctorError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}