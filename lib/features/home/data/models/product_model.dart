import 'package:alhakim/core/utils/constants.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/home/domain/entity/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    super.id,
    super.title,
    super.description,
    super.finalPrice,
    super.oldPrice,
    super.image,
    super.images,
    super.offerLabel,
    super.location,
    super.createdAt,
    super.categoryName,
    super.details,
    super.isNegotiable,
    super.phoneNumber,
    super.whatsappNumber,
    super.sellerName,
    super.sellerId,
    super.categoryId,
    super.subCategoryId,
    super.city,
    super.videoUrl,
    super.makingYear,
    super.communicateWay,
    super.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle images and photos
    String? mainImage;
    List<ProductImageEntity> allImages = [];

    // Check for 'photos' list (common in details response)
    if (json['photos'] != null && json['photos'] is List) {
      for (var photo in json['photos']) {
        if (photo is Map && photo['url'] != null) {
          allImages.add(
            ProductImageEntity(
              id: photo['id'] is String
                  ? (int.tryParse(photo['id']) ?? 0)
                  : (photo['id'] ?? 0),
              url: photo['url'].toString(),
            ),
          );
        }
      }
    }

    // Check for 'images' list
    if (json['images'] != null && json['images'] is List) {
      for (var img in json['images']) {
        if (img is Map && img['image'] != null) {
          allImages.add(
            ProductImageEntity(
              id: img['id'] is String
                  ? (int.tryParse(img['id']) ?? 0)
                  : (img['id'] ?? 0),
              url: img['image'].toString(),
            ),
          );
        }
      }
    }

    if (allImages.isNotEmpty) {
      mainImage = allImages.first.url;
    } else if (json['image'] != null) {
      mainImage = json['image'].toString();
    }

    // Handle user/seller info
    String? sName;
    int? sId;
    String? pNo;
    String? wNo;

    if (json['user'] != null && json['user'] is Map) {
      final user = json['user'] as Map<String, dynamic>;
      sName = user['name']?.toString();
      sId = user['id'] is String ? int.tryParse(user['id']) : user['id'];
      pNo = user['user_phone']?.toString();
      wNo = user['user_whatsapp']?.toString();
    } else {
      sName = json['user_name']?.toString();
      sId = json['user_id'] is String
          ? int.tryParse(json['user_id'])
          : json['user_id'];
    }

    String? loc =
        json['city']?['name'] ??
        json['city_id']?.toString() ??
        json['location']?.toString();

    // int? parsedCityId;
    // if (json['city'] != null && json['city'] is Map) {
    //   parsedCityId = json['city']['id'] is String
    //       ? int.tryParse(json['city']['id'])
    //       : json['city']['id'];
    // } else if (json['city_id'] != null) {
    //   parsedCityId = json['city_id'] is String
    //       ? int.tryParse(json['city_id'])
    //       : json['city_id'];
    // }

    String? catName =
        json['category']?['name'] ??
        json['category_name']?.toString() ??
        json['category_id']?.toString();

    int? parsedCategoryId;
    if (json['category'] != null && json['category'] is Map) {
      parsedCategoryId = json['category']['id'] is String
          ? int.tryParse(json['category']['id'])
          : json['category']['id'];
    } else if (json['category_id'] != null) {
      parsedCategoryId = json['category_id'] is String
          ? int.tryParse(json['category_id'])
          : json['category_id'];
    }

    int? parsedSubCategoryId;
    if (json['sub_category'] != null && json['sub_category'] is Map) {
      parsedSubCategoryId = json['sub_category']['id'] is String
          ? int.tryParse(json['sub_category']['id'])
          : json['sub_category']['id'];
    } else if (json['sub_category_id'] != null) {
      parsedSubCategoryId = json['sub_category_id'] is String
          ? int.tryParse(json['sub_category_id'])
          : json['sub_category_id'];
    }

    // Handle Video
    String? videoUrl;
    if (json['video'] != null && json['video'].toString().isNotEmpty) {
      videoUrl = json['video'].toString();
    }

    // Handle Communicate Way
    String? commWay = json['communicate_way']?.toString();

    // Handle details (Map<String, String>)
    Map<String, String>? detailsMap;
    if (json['details'] != null && json['details'] is Map) {
      detailsMap = (json['details'] as Map).map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    }

    return ProductModel(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      title: json['title']?.toString(),
      makingYear: json['making_year']?.toString(),
      description: json['description']?.toString(),
      finalPrice: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      oldPrice: json['old_price'] != null
          ? double.tryParse(json['old_price'].toString())
          : null,
      image: mainImage,
      images: allImages,
      offerLabel: json['offer_label']?.toString(),
      location: loc,
      createdAt: Constants.formatDate(json['created_at']?.toString()),
      categoryName: catName,
      details: detailsMap,
      isNegotiable:
          json['is_fixed'] == "0" ||
          json['is_fixed'] == 0 ||
          json['is_fixed'] == false,
      phoneNumber: pNo,
      whatsappNumber: wNo,
      sellerName: sName,
      sellerId: sId,
      categoryId: parsedCategoryId,
      subCategoryId: parsedSubCategoryId,
      city: CityModel.fromJson(json['city']),
      videoUrl: videoUrl,
      communicateWay: commWay,
      isFavorite: json['is_fav'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': finalPrice,
      'image': image,
      'created_at': createdAt,
      'is_fav': isFavorite,
    };
  }
}
