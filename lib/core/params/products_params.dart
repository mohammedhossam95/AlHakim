import 'package:equatable/equatable.dart';

class ProductsParams extends Equatable {
  final int? categoryId;
  final String? searchKey;
  final String? makingYear;
  final int? cityId;

  const ProductsParams({
    this.categoryId,
    this.searchKey,
    this.makingYear,
    this.cityId,
  });

  @override
  List<Object?> get props => [categoryId, searchKey, makingYear, cityId];
}
