class GetHospitalEmergencyParams {
  final int? perPage;
  final String? search;
  final int? categoryId;

  const GetHospitalEmergencyParams({
    this.perPage,
    this.search,
    this.categoryId,
  });

  Map<String, dynamic> toQuery() {
    final map = <String, dynamic>{};
    if (perPage != null) map['per_page'] = perPage;
    if (search != null && search!.isNotEmpty) map['search'] = search;
    if (categoryId != null) map['category_id'] = categoryId;
    return map;
  }

  GetHospitalEmergencyParams copyWith({
    int? perPage,
    String? search,
    int? categoryId,
  }) {
    return GetHospitalEmergencyParams(
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
