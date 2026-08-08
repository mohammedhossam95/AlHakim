class UpdateScheduleStatusParams {
  final String doctorId;
  final String scheduleId;
  final String scheduleStatus;

  const UpdateScheduleStatusParams({
    required this.doctorId,
    required this.scheduleId,
    required this.scheduleStatus,
  });

  Map<String, dynamic> toJson() => {
    '_method': 'PATCH',
    'schedule_status': scheduleStatus,
  };

  UpdateScheduleStatusParams copyWith({
    String? doctorId,
    String? scheduleId,
    String? scheduleStatus,
  }) {
    return UpdateScheduleStatusParams(
      doctorId: doctorId ?? this.doctorId,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduleStatus: scheduleStatus ?? this.scheduleStatus,
    );
  }
}
