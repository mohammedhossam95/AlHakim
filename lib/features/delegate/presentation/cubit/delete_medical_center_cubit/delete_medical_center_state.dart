part of 'delete_medical_center_cubit.dart';

sealed class DeleteMedicalCenterState extends Equatable {
  const DeleteMedicalCenterState();

  @override
  List<Object?> get props => [];
}

final class DeleteMedicalCenterInitial extends DeleteMedicalCenterState {}

final class DeleteMedicalCenterLoading extends DeleteMedicalCenterState {}

final class DeleteMedicalCenterSuccess extends DeleteMedicalCenterState {
  final BaseOneResponse response;

  const DeleteMedicalCenterSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class DeleteMedicalCenterError extends DeleteMedicalCenterState {
  final String message;

  const DeleteMedicalCenterError({required this.message});

  @override
  List<Object?> get props => [message];
}
