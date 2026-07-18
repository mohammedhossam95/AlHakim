class SearchDoctorsParams {
  final String search;
  final int perPage;

  const SearchDoctorsParams({
    required this.search,
    this.perPage = 15,
  });

  Map<String, dynamic> toJson() => {
        'search': search,
        'per_page': perPage,
      };

  SearchDoctorsParams copyWith({
    String? search,
    int? perPage,
  }) {
    return SearchDoctorsParams(
      search: search ?? this.search,
      perPage: perPage ?? this.perPage,
    );
  }
}
