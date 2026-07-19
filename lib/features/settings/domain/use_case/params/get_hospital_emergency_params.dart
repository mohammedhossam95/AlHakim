class GetHospitalEmergencyParams {
  final int? perPage;
  final String? search;

  const GetHospitalEmergencyParams({this.perPage, this.search});

  Map<String, dynamic> toQuery() {
    final map = <String, dynamic>{};
    if (perPage != null) map['per_page'] = perPage;
    if (search != null && search!.isNotEmpty) map['search'] = search;
    return map;
  }

  GetHospitalEmergencyParams copyWith({int? perPage, String? search}) {
    return GetHospitalEmergencyParams(
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
    );
  }
}
