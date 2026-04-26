import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final double? finalPrice;
  final double? oldPrice;
  final String? image;
  final List<ProductImageEntity>? images; // for carousel
  final String? offerLabel;
  final String? location;
  final String? createdAt;
  final String? categoryName;
  final Map<String, String>? details; // additional details
  final bool? isNegotiable; // negotiable tag
  final String? phoneNumber; // call button
  final String? whatsappNumber; // whatsapp button
  final String? sellerName; // optional for inquiries
  final int? sellerId; // optional for inquiries
  final int? categoryId;
  final int? subCategoryId;
  final CityEntity? city;
  final String? videoUrl;
  final String? makingYear;
  final String? communicateWay;
  final bool? isFavorite;

  const ProductEntity({
    this.id,
    this.title,
    this.description,
    this.finalPrice,
    this.oldPrice,
    this.image,
    this.makingYear,
    this.images,
    this.offerLabel,
    this.location,
    this.createdAt,
    this.categoryName,
    this.details,
    this.isNegotiable,
    this.phoneNumber,
    this.whatsappNumber,
    this.sellerName,
    this.sellerId,
    this.categoryId,
    this.subCategoryId,
    this.city,
    this.videoUrl,
    this.communicateWay,
    this.isFavorite,
  });

  // Helper to calculate discount percentage
  int? get discountPercentage {
    if (oldPrice == null || finalPrice == null || oldPrice! <= finalPrice!) {
      return null;
    }
    return (((oldPrice! - finalPrice!) / oldPrice!) * 100).round();
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    finalPrice,
    oldPrice,
    image,
    images,
    offerLabel,
    location,
    createdAt,
    categoryName,
    details,
    isNegotiable,
    phoneNumber,
    whatsappNumber,
    sellerName,
    sellerId,
    categoryId,
    subCategoryId,
    city,
    makingYear,
    videoUrl,
    communicateWay,
    isFavorite,
  ];
}

class ProductImageEntity extends Equatable {
  final int id;
  final String url;

  const ProductImageEntity({required this.id, required this.url});

  @override
  List<Object?> get props => [id, url];
}
