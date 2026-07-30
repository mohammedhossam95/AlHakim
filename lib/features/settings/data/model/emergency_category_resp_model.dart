import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/settings/domain/entity/emergency_category_entity.dart';

class EmergencyCategoryRespModel extends BaseListResponse {
  const EmergencyCategoryRespModel({super.status, super.message, super.data});

  factory EmergencyCategoryRespModel.fromJson(Map<String, dynamic> json) {
    return EmergencyCategoryRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null
          ? []
          : List<EmergencyCategoryModel>.from(
              (json['data'] as List).map(
                (x) => EmergencyCategoryModel.fromJson(x),
              ),
            ),
    );
  }
}

class EmergencyCategoryModel extends EmergencyCategoryEntity {
  const EmergencyCategoryModel({
    super.id,
    super.name,
    super.image,
    super.isActive,
  });

  factory EmergencyCategoryModel.fromJson(Map<String, dynamic> json) {
    return EmergencyCategoryModel(
      id: json['id'],
      name: json['name']?.toString(),
      image: json['image']?.toString(),
      isActive: json['is_active'],
    );
  }
}
