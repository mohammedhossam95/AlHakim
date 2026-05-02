import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/pagination.dart';
import 'package:alhakim/features/home/domain/entity/ads_entity.dart';

class AllAdsRespModel extends BaseListResponse {
  const AllAdsRespModel({
    super.status,
    super.data,
    super.pagination,
    super.message,
    super.success,
  });

  factory AllAdsRespModel.fromJson(Map<String, dynamic> json) {
    return AllAdsRespModel(
      //status: json['status'],
      message: json['message'],
      success: json['success'],
      data: (json['data'] as List?)?.map((e) => AdModel.fromJson(e)).toList(),
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'])
          : null,
    );
  }
}

/// =============================
/// Pagination Model
/// =============================
class PaginationModel extends Pagination {
  const PaginationModel({
    super.count,
    super.perPage,
    super.currentPage,
    super.totalPages,
    super.nextPageUrl,
    super.prevPageUrl,
    super.hasMore,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      count: json['count'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      hasMore: json['has_more'],
    );
  }
}

/// =============================
/// Photo Model
/// =============================
class PhotoModel extends PhotoEntity {
  const PhotoModel({super.id, super.url});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(id: json['id'], url: json['url']);
  }
}

/// =============================
/// Ad Model
/// =============================
class AdModel extends AdEntity {
  const AdModel({
    super.id,
    super.userId,
    super.title,
    super.slug,
    super.description,
    super.isFixed,
    super.fixedCategoryId,
    super.photos,
    super.price,
    super.createdAt,
    super.makingYear,
    super.categoryId,
    super.status,
    super.isFavorite,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      // city: CityModel.fromJson(json['city']),
      isFixed: json['is_fixed'],
      fixedCategoryId: json['fixed_category_id'],
      price: json['price'],
      createdAt: json['created_at'],
      makingYear: json['making_year'],
      categoryId: json['category_id'],
      status: json['status'],
      photos: (json['photos'] as List?)
          ?.map((e) => PhotoModel.fromJson(e))
          .toList(),
      isFavorite: json['is_fav'],
    );
  }
}
