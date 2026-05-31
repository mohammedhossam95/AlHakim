part of 'get_appointments_cubit.dart';

sealed class GetAppointmentsState
    extends Equatable {
  const GetAppointmentsState();

  @override
  List<Object?> get props => [];
}

final class GetAppointmentsInitial
    extends GetAppointmentsState {}

final class GetAppointmentsLoading
    extends GetAppointmentsState {}

final class GetAppointmentsSuccess
    extends GetAppointmentsState {
  final BaseListResponse response;

  const GetAppointmentsSuccess({
    required this.response,
  });

  @override
  List<Object?> get props => [response];
}

final class GetAppointmentsError
    extends GetAppointmentsState {
  final String message;

  const GetAppointmentsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}