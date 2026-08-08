part of 'update_schedule_status_cubit.dart';

sealed class UpdateScheduleStatusState extends Equatable {
  const UpdateScheduleStatusState();

  @override
  List<Object?> get props => [];
}

final class UpdateScheduleStatusInitial extends UpdateScheduleStatusState {}

final class UpdateScheduleStatusLoading extends UpdateScheduleStatusState {}

final class UpdateScheduleStatusSuccess extends UpdateScheduleStatusState {
  final BaseOneResponse response;

  const UpdateScheduleStatusSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class UpdateScheduleStatusError extends UpdateScheduleStatusState {
  final String message;

  const UpdateScheduleStatusError({required this.message});

  @override
  List<Object?> get props => [message];
}
