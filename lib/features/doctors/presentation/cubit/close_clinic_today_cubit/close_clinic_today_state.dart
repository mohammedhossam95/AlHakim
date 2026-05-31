part of 'close_clinic_today_cubit.dart';

sealed class CloseClinicTodayState extends Equatable {
  const CloseClinicTodayState();

  @override
  List<Object?> get props => [];
}

final class CloseClinicTodayInitial extends CloseClinicTodayState {}

final class CloseClinicTodayLoading extends CloseClinicTodayState {}

final class CloseClinicTodaySuccess extends CloseClinicTodayState {
  final BaseOneResponse response;

  const CloseClinicTodaySuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class CloseClinicTodayError extends CloseClinicTodayState {
  final String message;

  const CloseClinicTodayError({required this.message});

  @override
  List<Object?> get props => [message];
}
