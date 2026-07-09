part of 'session_cubit.dart';

class SessionState extends Equatable {
  final SessionStatus status;
  final UserType userType;
  final DoctorAccountMode? doctorAccountMode;
  final String? activeDoctorId;
  final DoctorEntity? selectedDoctor;
  final String? error;

  const SessionState({
    required this.status,
    required this.userType,
    this.doctorAccountMode,
    this.activeDoctorId,
    this.selectedDoctor,
    this.error,
  });

  const SessionState.initial()
    : status = SessionStatus.firstLaunch,
      userType = UserType.patient,
      doctorAccountMode = null,
      activeDoctorId = null,
      selectedDoctor = null,
      error = null;

  bool get isDoctor => userType == UserType.doctor;

  bool get isMedicalCenterDoctorAccount =>
      userType == UserType.doctor &&
      doctorAccountMode == DoctorAccountMode.medicalCenter;

  bool get needsDoctorSelection =>
      isMedicalCenterDoctorAccount && activeDoctorId == null;

  SessionState copyWith({
    SessionStatus? status,
    UserType? userType,
    DoctorAccountMode? doctorAccountMode,
    String? activeDoctorId,
    DoctorEntity? selectedDoctor,
    String? error,
    bool clearSelectedDoctor = false,
  }) {
    return SessionState(
      status: status ?? this.status,
      userType: userType ?? this.userType,
      doctorAccountMode: doctorAccountMode ?? this.doctorAccountMode,
      activeDoctorId: clearSelectedDoctor
          ? null
          : activeDoctorId ?? this.activeDoctorId,
      selectedDoctor: clearSelectedDoctor
          ? null
          : selectedDoctor ?? this.selectedDoctor,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userType,
    doctorAccountMode,
    activeDoctorId,
    selectedDoctor,
    error,
  ];
}
