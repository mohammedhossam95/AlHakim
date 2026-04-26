import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/settings/domain/entity/static_page_entity.dart';

class StaticPageContentRespModel extends BaseOneResponse {
  const StaticPageContentRespModel({super.success, super.data, super.message});

  factory StaticPageContentRespModel.fromJson(Map<String, dynamic> json) {
    return StaticPageContentRespModel(data: StaticPageModel.fromJson(json));
  }
}

class StaticPageModel extends StaticPageEntity {
  const StaticPageModel({super.id, super.key, super.value});

  factory StaticPageModel.fromJson(Map<String, dynamic> json) {
    return StaticPageModel(key: json['key'], value: json['value']);
  }
}
