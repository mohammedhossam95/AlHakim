part of 'cancel_appointment_cubit.dart';

sealed class CancelAppointmentState extends Equatable {
  const CancelAppointmentState();

  @override
  List<Object?> get props => [];
}

final class CancelAppointmentInitial extends CancelAppointmentState {}

final class CancelAppointmentLoading extends CancelAppointmentState {}

final class CancelAppointmentSuccess extends CancelAppointmentState {
  final BaseOneResponse response;

  const CancelAppointmentSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class CancelAppointmentError extends CancelAppointmentState {
  final String message;

  const CancelAppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}
