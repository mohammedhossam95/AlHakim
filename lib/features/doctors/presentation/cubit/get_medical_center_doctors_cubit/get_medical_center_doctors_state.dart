part of 'get_medical_center_doctors_cubit.dart';

sealed class GetMedicalCenterDoctorsState extends Equatable {
  const GetMedicalCenterDoctorsState();

  @override
  List<Object> get props => [];
}

class GetMedicalCenterDoctorsInitial extends GetMedicalCenterDoctorsState {}

class GetMedicalCenterDoctorsLoading extends GetMedicalCenterDoctorsState {}

class GetMedicalCenterDoctorsSuccess extends GetMedicalCenterDoctorsState {
  final BaseListResponse response;

  const GetMedicalCenterDoctorsSuccess({required this.response});
}

class GetMedicalCenterDoctorsError extends GetMedicalCenterDoctorsState {
  final String message;

  const GetMedicalCenterDoctorsError({required this.message});
}
