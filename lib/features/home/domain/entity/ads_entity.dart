import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

// --- Advertisement Entity ---
class AdEntity extends Equatable {
  final int? id;
  final String? userId;
  final String? title;
  final String? slug;
  final String? description;
  final CityEntity? city;
  final String? isFixed;
  final int? fixedCategoryId;
  final List<PhotoEntity>? photos;
  final String? price;
  final String? createdAt;
  final String? makingYear;
  final String? categoryId;
  final String? status;
  final bool? isFavorite;

  const AdEntity({
    this.id,
    this.userId,
    this.title,
    this.slug,
    this.description,
    this.city,
    this.isFixed,
    this.fixedCategoryId,
    this.photos,
    this.price,
    this.createdAt,
    this.makingYear,
    this.categoryId,
    this.status,
    this.isFavorite,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    slug,
    description,
    city,
    isFixed,
    fixedCategoryId,
    photos,
    price,
    createdAt,
    makingYear,
    categoryId,
    status,
    isFavorite,
  ];
}

// --- Photo Entity ---
class PhotoEntity extends Equatable {
  final int? id;
  final String? url;

  const PhotoEntity({this.id, this.url});

  @override
  List<Object?> get props => [id, url];
}

class AdsParams {
  final int? id;
  final int? currentPage;
  final String? search;

  const AdsParams({required this.currentPage, this.search, this.id});
}
