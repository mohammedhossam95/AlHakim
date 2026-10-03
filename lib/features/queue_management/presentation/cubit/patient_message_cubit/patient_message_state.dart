part of 'patient_message_cubit.dart';

sealed class PatientMessageState extends Equatable {
  const PatientMessageState();

  @override
  List<Object?> get props => [];
}

final class PatientMessageInitial extends PatientMessageState {}

final class PatientMessageLoading extends PatientMessageState {}

final class PatientMessageSuccess extends PatientMessageState {
  final BaseOneResponse response;

  const PatientMessageSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class PatientMessageError extends PatientMessageState {
  final String message;

  const PatientMessageError({required this.message});

  @override
  List<Object?> get props => [message];
}
