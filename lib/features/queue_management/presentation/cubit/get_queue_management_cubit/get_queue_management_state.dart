part of 'get_queue_management_cubit.dart';

sealed class GetQueueManagementState extends Equatable {
  const GetQueueManagementState();

  @override
  List<Object?> get props => [];
}

final class GetQueueManagementInitial extends GetQueueManagementState {}

final class GetQueueManagementLoading extends GetQueueManagementState {}

final class GetQueueManagementSuccess extends GetQueueManagementState {
  final BaseListResponse response;

  const GetQueueManagementSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetQueueManagementError extends GetQueueManagementState {
  final String message;

  const GetQueueManagementError({required this.message});

  @override
  List<Object?> get props => [message];
}
