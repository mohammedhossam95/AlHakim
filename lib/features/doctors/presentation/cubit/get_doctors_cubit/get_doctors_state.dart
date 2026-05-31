part of 'get_doctors_cubit.dart';

sealed class GetDoctorsState extends Equatable {
  const GetDoctorsState();

  @override
  List<Object> get props => [];
}

class GetDoctorsInitial extends GetDoctorsState {}

class GetDoctorsLoading extends GetDoctorsState {}

class GetDoctorsSuccess extends GetDoctorsState {
  final BaseListResponse response;

  const GetDoctorsSuccess({required this.response});
}

class GetDoctorsError extends GetDoctorsState {
  final String message;

  const GetDoctorsError({required this.message});
}
