class BookingParams {
  final String doctorId;
  final String appointmentDate;
  final int appointmentTypeId;
  final String? appointmentType;
  final String? familyMemberId;

  const BookingParams({
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTypeId,
    this.appointmentType,
    this.familyMemberId,
  });

  Map<String, dynamic> toJson() => {
    'doctor_id': doctorId,
    'appointment_date': appointmentDate,
    'appointment_type_id': appointmentTypeId,
    if (familyMemberId != null && familyMemberId!.isNotEmpty)
      'family_member_id': familyMemberId,
  };

  BookingParams copyWith({
    String? doctorId,
    String? appointmentDate,
    int? appointmentTypeId,
    String? familyMemberId,
  }) {
    return BookingParams(
      doctorId: doctorId ?? this.doctorId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTypeId: appointmentTypeId ?? this.appointmentTypeId,
      familyMemberId: familyMemberId ?? this.familyMemberId,
    );
  }
}
