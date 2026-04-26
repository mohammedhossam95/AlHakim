import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/home/domain/entity/slider_entity.dart';

class HomeBannersRespModel extends BaseListResponse {
  const HomeBannersRespModel({super.success, super.message, super.data});

  factory HomeBannersRespModel.fromJson(Map<String, dynamic> json) {
    return HomeBannersRespModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<BannerModel>.from(
              json['data'].map((e) => BannerModel.fromJson(e)),
            )
          : [],
    );
  }
}

class BannerModel extends SliderEntity {
  const BannerModel({super.id, super.image, super.link});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "image": image, "link": link};
  }
}
