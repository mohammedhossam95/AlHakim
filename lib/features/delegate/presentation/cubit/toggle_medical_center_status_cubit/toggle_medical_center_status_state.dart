part of 'toggle_medical_center_status_cubit.dart';

sealed class ToggleMedicalCenterStatusState extends Equatable {
  const ToggleMedicalCenterStatusState();

  @override
  List<Object?> get props => [];
}

final class ToggleMedicalCenterStatusInitial
    extends ToggleMedicalCenterStatusState {}

final class ToggleMedicalCenterStatusLoading
    extends ToggleMedicalCenterStatusState {}

final class ToggleMedicalCenterStatusSuccess
    extends ToggleMedicalCenterStatusState {
  final BaseOneResponse response;

  const ToggleMedicalCenterStatusSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class ToggleMedicalCenterStatusError
    extends ToggleMedicalCenterStatusState {
  final String message;

  const ToggleMedicalCenterStatusError({required this.message});

  @override
  List<Object?> get props => [message];
}
