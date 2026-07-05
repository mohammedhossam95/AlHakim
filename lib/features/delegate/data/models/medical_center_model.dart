import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/delegate/domain/entities/medical_center_entity.dart';

class MedicalCentersRespModel extends BaseListResponse {
  const MedicalCentersRespModel({super.status, super.message, super.data});

  factory MedicalCentersRespModel.fromJson(Map<String, dynamic> json) {
    return MedicalCentersRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null
          ? []
          : List<MedicalCenterModel>.from(
              (json['data'] as List).map(
                (x) => MedicalCenterModel.fromJson(x),
              ),
            ),
    );
  }
}

class MedicalCenterModel extends MedicalCenterEntity {
  const MedicalCenterModel({
    super.id,
    super.name,
    super.description,
    super.address,
    super.countryCode,
    super.phone,
    super.email,
    super.logo,
    super.cover,
    super.isActive,
    super.createdAt,
  });

  factory MedicalCenterModel.fromJson(Map<String, dynamic> json) {
    return MedicalCenterModel(
      id: json['id'],
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      address: json['address']?.toString(),
      countryCode: json['country_code']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      logo: json['logo']?.toString(),
      cover: json['cover']?.toString(),
      isActive: json['is_active'],
      createdAt: json['created_at']?.toString(),
    );
  }
}
