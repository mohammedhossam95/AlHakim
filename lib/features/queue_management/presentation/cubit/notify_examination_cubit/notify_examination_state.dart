part of 'notify_examination_cubit.dart';

sealed class NotifyExaminationState extends Equatable {
  const NotifyExaminationState();

  @override
  List<Object?> get props => [];
}

final class NotifyExaminationInitial extends NotifyExaminationState {}

final class NotifyExaminationLoading extends NotifyExaminationState {
  final String appointmentId;

  const NotifyExaminationLoading({required this.appointmentId});

  @override
  List<Object?> get props => [appointmentId];
}

final class NotifyExaminationSuccess extends NotifyExaminationState {
  final BaseOneResponse response;

  const NotifyExaminationSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class NotifyExaminationError extends NotifyExaminationState {
  final String message;

  const NotifyExaminationError({required this.message});

  @override
  List<Object?> get props => [message];
}
