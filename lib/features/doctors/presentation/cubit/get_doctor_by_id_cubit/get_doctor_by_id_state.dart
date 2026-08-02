part of 'get_doctor_by_id_cubit.dart';

sealed class GetDoctorByIdState extends Equatable {
  const GetDoctorByIdState();

  @override
  List<Object?> get props => [];
}

final class GetDoctorByIdInitial extends GetDoctorByIdState {}

final class GetDoctorByIdLoading extends GetDoctorByIdState {}

final class GetDoctorByIdSuccess extends GetDoctorByIdState {
  final DoctorEntity doctor;

  const GetDoctorByIdSuccess({required this.doctor});

  @override
  List<Object?> get props => [doctor];
}

final class GetDoctorByIdError extends GetDoctorByIdState {
  final String message;

  const GetDoctorByIdError({required this.message});

  @override
  List<Object?> get props => [message];
}
