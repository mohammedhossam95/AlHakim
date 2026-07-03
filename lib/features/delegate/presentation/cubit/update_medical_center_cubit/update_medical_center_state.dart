part of 'update_medical_center_cubit.dart';

sealed class UpdateMedicalCenterState extends Equatable {
  const UpdateMedicalCenterState();

  @override
  List<Object?> get props => [];
}

final class UpdateMedicalCenterInitial extends UpdateMedicalCenterState {}

final class UpdateMedicalCenterLoading extends UpdateMedicalCenterState {}

final class UpdateMedicalCenterSuccess extends UpdateMedicalCenterState {
  final BaseOneResponse response;

  const UpdateMedicalCenterSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class UpdateMedicalCenterError extends UpdateMedicalCenterState {
  final String message;

  const UpdateMedicalCenterError({required this.message});

  @override
  List<Object?> get props => [message];
}
