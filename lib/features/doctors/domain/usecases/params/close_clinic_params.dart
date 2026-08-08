class CloseClinicParams {
  final String doctorId;
  final String date;
  final String reason;

  const CloseClinicParams({
    required this.doctorId,
    required this.date,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'reason': reason,
  };

  CloseClinicParams copyWith({
    String? doctorId,
    String? date,
    String? reason,
  }) {
    return CloseClinicParams(
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      reason: reason ?? this.reason,
    );
  }
}
