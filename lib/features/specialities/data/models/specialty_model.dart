import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/specialities/domain/entities/specialty_entity.dart';

class SpecialtiesRespModel extends BaseListResponse {
  const SpecialtiesRespModel({super.status, super.message, super.data});

  factory SpecialtiesRespModel.fromJson(Map<String, dynamic> json) {
    return SpecialtiesRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => SpecialtyModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class SpecialtyModel extends SpecialtyEntity {
  const SpecialtyModel({
    super.id,
    super.icon,
    super.mainSpecialty,
    super.isActive,
    super.sortOrder,
    super.name,
    super.slug,
    super.hasChildren,
    super.doctorsCount,
    super.createdAt,
    super.updatedAt,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'],
      icon: json['icon'],
      isActive: json['is_active'],
      sortOrder: json['sort_order'],
      name: json['name'],
      slug: json['slug'],
      hasChildren: json['has_children'],
      doctorsCount: json['doctors_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],

      mainSpecialty: json['main_specialty'] != null
          ? SpecialtyModel.fromJson(json['main_specialty'])
          : null,
    );
  }
}
