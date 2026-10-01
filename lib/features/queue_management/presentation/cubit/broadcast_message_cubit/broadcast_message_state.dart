part of 'broadcast_message_cubit.dart';

sealed class BroadcastMessageState extends Equatable {
  const BroadcastMessageState();

  @override
  List<Object?> get props => [];
}

final class BroadcastMessageInitial extends BroadcastMessageState {}

final class BroadcastMessageLoading extends BroadcastMessageState {}

final class BroadcastMessageSuccess extends BroadcastMessageState {
  final BaseOneResponse response;

  const BroadcastMessageSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class BroadcastMessageError extends BroadcastMessageState {
  final String message;

  const BroadcastMessageError({required this.message});

  @override
  List<Object?> get props => [message];
}
