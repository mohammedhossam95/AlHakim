part of 'get_doctor_appoinments_for_day_cubit.dart';

sealed class GetDoctorAppoinmentsForDayState extends Equatable {
  const GetDoctorAppoinmentsForDayState();

  @override
  List<Object?> get props => [];
}

final class GetDoctorAppoinmentsForDayInitial
    extends GetDoctorAppoinmentsForDayState {}

final class GetDoctorAppoinmentsForDayLoading
    extends GetDoctorAppoinmentsForDayState {}

final class GetDoctorAppoinmentsForDaySuccess
    extends GetDoctorAppoinmentsForDayState {
  final BaseListResponse response;

  const GetDoctorAppoinmentsForDaySuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetDoctorAppoinmentsForDayError
    extends GetDoctorAppoinmentsForDayState {
  final String message;

  const GetDoctorAppoinmentsForDayError({required this.message});

  @override
  List<Object?> get props => [message];
}
