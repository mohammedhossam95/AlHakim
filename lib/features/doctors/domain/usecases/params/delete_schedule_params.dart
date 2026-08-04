class DeleteScheduleParams {
  final String doctorId;
  final String scheduleId;

  const DeleteScheduleParams({
    required this.doctorId,
    required this.scheduleId,
  });

  DeleteScheduleParams copyWith({
    String? doctorId,
    String? scheduleId,
  }) {
    return DeleteScheduleParams(
      doctorId: doctorId ?? this.doctorId,
      scheduleId: scheduleId ?? this.scheduleId,
    );
  }
}
