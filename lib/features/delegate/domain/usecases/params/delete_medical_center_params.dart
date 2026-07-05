class DeleteMedicalCenterParams {
  final String medicalCenterId;

  const DeleteMedicalCenterParams({required this.medicalCenterId});

  DeleteMedicalCenterParams copyWith({String? medicalCenterId}) {
    return DeleteMedicalCenterParams(
      medicalCenterId: medicalCenterId ?? this.medicalCenterId,
    );
  }
}
