part of 'get_queue_status_cubit.dart';

sealed class GetQueueStatusState extends Equatable {
  const GetQueueStatusState();

  @override
  List<Object?> get props => [];
}

final class GetQueueStatusInitial extends GetQueueStatusState {}

final class GetQueueStatusLoading extends GetQueueStatusState {}

final class GetQueueStatusSuccess extends GetQueueStatusState {
  final BaseOneResponse response;

  const GetQueueStatusSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetQueueStatusError extends GetQueueStatusState {
  final String message;

  const GetQueueStatusError({required this.message});

  @override
  List<Object?> get props => [message];
}
