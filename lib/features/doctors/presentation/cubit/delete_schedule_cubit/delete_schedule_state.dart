part of 'delete_schedule_cubit.dart';

sealed class DeleteScheduleState extends Equatable {
  const DeleteScheduleState();

  @override
  List<Object?> get props => [];
}

final class DeleteScheduleInitial extends DeleteScheduleState {}

final class DeleteScheduleLoading extends DeleteScheduleState {}

final class DeleteScheduleSuccess extends DeleteScheduleState {
  final BaseOneResponse response;

  const DeleteScheduleSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class DeleteScheduleError extends DeleteScheduleState {
  final String message;

  const DeleteScheduleError({required this.message});

  @override
  List<Object?> get props => [message];
}
