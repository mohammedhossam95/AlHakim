part of 'export_appointments_cubit.dart';

abstract class ExportAppointmentsState extends Equatable {
  const ExportAppointmentsState();

  @override
  List<Object?> get props => [];
}

class ExportAppointmentsInitial extends ExportAppointmentsState {}

class ExportAppointmentsLoading extends ExportAppointmentsState {}

class ExportAppointmentsSuccess extends ExportAppointmentsState {
  final String filePath;

  const ExportAppointmentsSuccess({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class ExportAppointmentsError extends ExportAppointmentsState {
  final String message;

  const ExportAppointmentsError({required this.message});

  @override
  List<Object?> get props => [message];
}
