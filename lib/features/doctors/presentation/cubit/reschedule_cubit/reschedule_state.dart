part of 'reschedule_cubit.dart';

sealed class RescheduleState extends Equatable {
  const RescheduleState();

  @override
  List<Object?> get props => [];
}

final class RescheduleInitial extends RescheduleState {}

final class RescheduleLoading extends RescheduleState {}

final class RescheduleSuccess extends RescheduleState {
  final BaseOneResponse response;

  const RescheduleSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class RescheduleError extends RescheduleState {
  final String message;

  const RescheduleError({required this.message});

  @override
  List<Object?> get props => [message];
}
