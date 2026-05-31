part of 'update_queue_status_cubit.dart';

sealed class UpdateQueueStatusState extends Equatable {
  const UpdateQueueStatusState();

  @override
  List<Object?> get props => [];
}

final class UpdateQueueStatusInitial extends UpdateQueueStatusState {}

final class UpdateQueueStatusLoading extends UpdateQueueStatusState {
  final int appointmentId;

  const UpdateQueueStatusLoading({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}

final class UpdateQueueStatusSuccess extends UpdateQueueStatusState {
  final BaseOneResponse response;

  const UpdateQueueStatusSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class UpdateQueueStatusError extends UpdateQueueStatusState {
  final String message;

  const UpdateQueueStatusError({required this.message});

  @override
  List<Object?> get props => [message];
}
