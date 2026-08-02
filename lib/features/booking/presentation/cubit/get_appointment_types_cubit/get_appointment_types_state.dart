part of 'get_appointment_types_cubit.dart';

sealed class GetAppointmentTypesState extends Equatable {
  const GetAppointmentTypesState();

  @override
  List<Object?> get props => [];
}

final class GetAppointmentTypesInitial extends GetAppointmentTypesState {}

final class GetAppointmentTypesLoading extends GetAppointmentTypesState {}

final class GetAppointmentTypesSuccess extends GetAppointmentTypesState {
  final BaseListResponse response;

  const GetAppointmentTypesSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetAppointmentTypesError extends GetAppointmentTypesState {
  final String message;

  const GetAppointmentTypesError({required this.message});

  @override
  List<Object?> get props => [message];
}
