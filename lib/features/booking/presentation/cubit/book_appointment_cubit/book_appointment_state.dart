part of 'book_appointment_cubit.dart';

sealed class BookAppointmentState extends Equatable {
  const BookAppointmentState();

  @override
  List<Object?> get props => [];
}

final class BookAppointmentInitial extends BookAppointmentState {}

final class BookAppointmentLoading extends BookAppointmentState {}

final class BookAppointmentSuccess extends BookAppointmentState {
  final BaseOneResponse response;

  const BookAppointmentSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class BookAppointmentError extends BookAppointmentState {
  final String message;

  const BookAppointmentError({required this.message});

  @override
  List<Object?> get props => [message];
}
