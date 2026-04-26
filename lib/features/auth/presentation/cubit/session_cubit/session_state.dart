part of 'session_cubit.dart';

class SessionState extends Equatable {
  final SessionStatus status;
  final String? error;

  const SessionState({required this.status, this.error});

  const SessionState.initial()
    : status = SessionStatus.guest,
      error = null;

  @override
  List<Object?> get props => [status, error];
}
