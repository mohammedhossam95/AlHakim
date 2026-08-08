part of 'close_clinic_cubit.dart';

sealed class CloseClinicState extends Equatable {
  const CloseClinicState();

  @override
  List<Object?> get props => [];
}

final class CloseClinicInitial extends CloseClinicState {}

final class CloseClinicLoading extends CloseClinicState {}

final class CloseClinicSuccess extends CloseClinicState {
  final BaseOneResponse response;

  const CloseClinicSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class CloseClinicError extends CloseClinicState {
  final String message;

  const CloseClinicError({required this.message});

  @override
  List<Object?> get props => [message];
}
