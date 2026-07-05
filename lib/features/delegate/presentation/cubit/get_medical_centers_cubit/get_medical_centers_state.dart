part of 'get_medical_centers_cubit.dart';

sealed class GetMedicalCentersState extends Equatable {
  const GetMedicalCentersState();

  @override
  List<Object?> get props => [];
}

final class GetMedicalCentersInitial extends GetMedicalCentersState {}

final class GetMedicalCentersLoading extends GetMedicalCentersState {}

final class GetMedicalCentersSuccess extends GetMedicalCentersState {
  final BaseListResponse response;

  const GetMedicalCentersSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetMedicalCentersError extends GetMedicalCentersState {
  final String message;

  const GetMedicalCentersError({required this.message});

  @override
  List<Object?> get props => [message];
}
