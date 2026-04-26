import 'package:equatable/equatable.dart';

class GetSubcategoriesParams extends Equatable {
  final int? parentCategoryId;
  final int? subCategoryId;

  const GetSubcategoriesParams({this.parentCategoryId, this.subCategoryId});

  Map<String, dynamic> toJson() => {'parent_category_id': parentCategoryId};

  Map<String, dynamic> toSubSubCategoryJson() => {'sub_category_id': subCategoryId};

  @override
  List<Object?> get props => [parentCategoryId, subCategoryId];
}
