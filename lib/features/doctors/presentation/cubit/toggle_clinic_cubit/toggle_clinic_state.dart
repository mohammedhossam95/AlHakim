part of 'toggle_clinic_cubit.dart';

sealed class ToggleClinicState extends Equatable {
  const ToggleClinicState();

  @override
  List<Object?> get props => [];
}

final class ToggleClinicInitial extends ToggleClinicState {}

final class ToggleClinicLoading extends ToggleClinicState {}

final class ToggleClinicSuccess extends ToggleClinicState {
  final BaseOneResponse response;

  const ToggleClinicSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class ToggleClinicError extends ToggleClinicState {
  final String message;

  const ToggleClinicError({required this.message});

  @override
  List<Object?> get props => [message];
}
