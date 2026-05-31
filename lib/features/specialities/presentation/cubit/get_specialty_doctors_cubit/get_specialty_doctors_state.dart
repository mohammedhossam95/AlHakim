part of 'get_specialty_doctors_cubit.dart';

sealed class GetSpecialtyDoctorsState extends Equatable {
  const GetSpecialtyDoctorsState();

  @override
  List<Object?> get props => [];
}

final class GetSpecialtyDoctorsInitial extends GetSpecialtyDoctorsState {}

final class GetSpecialtyDoctorsLoading extends GetSpecialtyDoctorsState {}

final class GetSpecialtyDoctorsSuccess extends GetSpecialtyDoctorsState {
  final BaseListResponse response;

  const GetSpecialtyDoctorsSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetSpecialtyDoctorsError extends GetSpecialtyDoctorsState {
  final String message;

  const GetSpecialtyDoctorsError({required this.message});

  @override
  List<Object?> get props => [message];
}
