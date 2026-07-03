class ToggleMedicalCenterStatusParams {
  final String medicalCenterId;

  const ToggleMedicalCenterStatusParams({required this.medicalCenterId});

  ToggleMedicalCenterStatusParams copyWith({String? medicalCenterId}) {
    return ToggleMedicalCenterStatusParams(
      medicalCenterId: medicalCenterId ?? this.medicalCenterId,
    );
  }
}
