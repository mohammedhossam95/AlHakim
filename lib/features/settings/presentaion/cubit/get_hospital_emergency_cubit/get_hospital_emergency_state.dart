part of 'get_hospital_emergency_cubit.dart';

sealed class GetHospitalEmergencyState extends Equatable {
  const GetHospitalEmergencyState();

  @override
  List<Object?> get props => [];
}

final class GetHospitalEmergencyInitial extends GetHospitalEmergencyState {}

final class GetHospitalEmergencyLoading extends GetHospitalEmergencyState {}

final class GetHospitalEmergencySuccess extends GetHospitalEmergencyState {
  final BaseListResponse response;

  const GetHospitalEmergencySuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetHospitalEmergencyError extends GetHospitalEmergencyState {
  final String message;

  const GetHospitalEmergencyError({required this.message});

  @override
  List<Object?> get props => [message];
}
