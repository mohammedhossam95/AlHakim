class GetHospitalEmergencyParams {
  final int? perPage;
  final String? hospitalName;
  final int? categoryId;

  const GetHospitalEmergencyParams({
    this.perPage,
    this.hospitalName,
    this.categoryId,
  });

  Map<String, dynamic> toQuery() {
    final map = <String, dynamic>{};
    if (perPage != null) map['per_page'] = perPage;
    if (hospitalName != null && hospitalName!.trim().isNotEmpty) {
      map['hospital_name'] = hospitalName!.trim();
    }
    if (categoryId != null) map['category_id'] = categoryId;
    return map;
  }

  GetHospitalEmergencyParams copyWith({
    int? perPage,
    String? hospitalName,
    int? categoryId,
  }) {
    return GetHospitalEmergencyParams(
      perPage: perPage ?? this.perPage,
      hospitalName: hospitalName ?? this.hospitalName,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
