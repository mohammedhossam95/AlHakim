part of 'add_medical_center_cubit.dart';

sealed class AddMedicalCenterState extends Equatable {
  const AddMedicalCenterState();

  @override
  List<Object?> get props => [];
}

final class AddMedicalCenterInitial extends AddMedicalCenterState {}

final class AddMedicalCenterLoading extends AddMedicalCenterState {}

final class AddMedicalCenterSuccess extends AddMedicalCenterState {
  final BaseOneResponse response;

  const AddMedicalCenterSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class AddMedicalCenterError extends AddMedicalCenterState {
  final String message;

  const AddMedicalCenterError({required this.message});

  @override
  List<Object?> get props => [message];
}
