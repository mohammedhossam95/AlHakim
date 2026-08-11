class GetHospitalEmergencyParams {
  final int? perPage;
  final String? hospitalName;
  final int? categoryId;
  final int? isOffered;

  const GetHospitalEmergencyParams({
    this.perPage,
    this.hospitalName,
    this.categoryId,
    this.isOffered,
  });

  Map<String, dynamic> toQuery() {
    final map = <String, dynamic>{};
    if (perPage != null) map['per_page'] = perPage;
    if (hospitalName != null && hospitalName!.trim().isNotEmpty) {
      map['hospital_name'] = hospitalName!.trim();
    }
    if (categoryId != null) map['category_id'] = categoryId;
    if (isOffered != null) map['is_offered'] = isOffered;
    return map;
  }

  GetHospitalEmergencyParams copyWith({
    int? perPage,
    String? hospitalName,
    int? categoryId,
    int? isOffered,
  }) {
    return GetHospitalEmergencyParams(
      perPage: perPage ?? this.perPage,
      hospitalName: hospitalName ?? this.hospitalName,
      categoryId: categoryId ?? this.categoryId,
      isOffered: isOffered ?? this.isOffered,
    );
  }
}
