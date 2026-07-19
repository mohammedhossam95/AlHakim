class GetSpecialtyDoctorsParams {
  final int specialtyId;
  final String? search;
  final int perPage;

  const GetSpecialtyDoctorsParams({
    required this.specialtyId,
    this.search,
    this.perPage = 15,
  });

  Map<String, dynamic> toJson() => {
        'specialty_id': specialtyId,
        'search': search,
        'per_page': perPage,
      };

  GetSpecialtyDoctorsParams copyWith({
    int? specialtyId,
    String? search,
    int? perPage,
  }) {
    return GetSpecialtyDoctorsParams(
      specialtyId: specialtyId ?? this.specialtyId,
      search: search ?? this.search,
      perPage: perPage ?? this.perPage,
    );
  }
}
