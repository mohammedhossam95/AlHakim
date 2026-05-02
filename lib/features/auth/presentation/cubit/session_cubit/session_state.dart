part of 'session_cubit.dart';

class SessionState extends Equatable {
  final SessionStatus status;
  final UserType userType;
  final String? error;

  const SessionState({
    required this.status,
    required this.userType,
    this.error,
  });

  const SessionState.initial()
    : status = SessionStatus.firstLaunch,
      userType = UserType.patient,
      error = null;

  SessionState copyWith({
    SessionStatus? status,
    UserType? userType,
    String? error,
  }) {
    return SessionState(
      status: status ?? this.status,
      userType: userType ?? this.userType,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, userType, error];
}
