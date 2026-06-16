class GetQueueStatusParams {
  final String appointmentId;

  const GetQueueStatusParams({required this.appointmentId});

  GetQueueStatusParams copyWith({String? appointmentId}) {
    return GetQueueStatusParams(
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }
}
