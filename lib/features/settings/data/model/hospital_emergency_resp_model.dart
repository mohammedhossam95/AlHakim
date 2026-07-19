import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/settings/domain/entity/hospital_emergency_entity.dart';

class HospitalEmergencyRespModel extends BaseListResponse {
  const HospitalEmergencyRespModel({super.status, super.message, super.data});

  factory HospitalEmergencyRespModel.fromJson(Map<String, dynamic> json) {
    return HospitalEmergencyRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null
          ? []
          : List<HospitalEmergencyModel>.from(
              (json['data'] as List).map(
                (x) => HospitalEmergencyModel.fromJson(x),
              ),
            ),
    );
  }
}

class HospitalEmergencyModel extends HospitalEmergencyEntity {
  const HospitalEmergencyModel({
    super.id,
    super.name,
    super.number,
    super.description,
    super.location,
    super.lat,
    super.lng,
    super.image,
    super.tags,
  });

  factory HospitalEmergencyModel.fromJson(Map<String, dynamic> json) {
    return HospitalEmergencyModel(
      id: json['id'],
      name: json['name']?.toString(),
      number: json['number']?.toString(),
      description: json['description']?.toString(),
      location: json['location']?.toString(),
      lat: json['lat'] == null
          ? null
          : double.tryParse(json['lat'].toString()),
      lng: json['lng'] == null
          ? null
          : double.tryParse(json['lng'].toString()),
      image: json['image']?.toString(),
      tags: json['tags'] == null
          ? []
          : List<String>.from(
              (json['tags'] as List).map((e) => e.toString()),
            ),
    );
  }
}
