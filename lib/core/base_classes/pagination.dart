import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? count;
  final int? totalPages;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final bool? hasMore;

  const Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.count,
    this.totalPages,
    this.nextPageUrl,
    this.prevPageUrl,
    this.hasMore
  });

  @override
  List<Object?> get props => [
    currentPage,
    lastPage,
    perPage,
    count,
    totalPages,
    nextPageUrl,
    prevPageUrl,
    hasMore
  ];
}
