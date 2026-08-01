class UpdateFamilyMemberParams {
  final String id;
  final String fullName;
  final String birthDate;

  const UpdateFamilyMemberParams({
    required this.id,
    required this.fullName,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'birth_date': birthDate,
      };

  UpdateFamilyMemberParams copyWith({
    String? id,
    String? fullName,
    String? birthDate,
  }) {
    return UpdateFamilyMemberParams(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
