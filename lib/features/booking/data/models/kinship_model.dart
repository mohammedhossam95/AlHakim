import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/booking/domain/entities/kinship_entity.dart';

class KinshipRespModel extends BaseListResponse {
  const KinshipRespModel({super.status, super.message, super.data});

  factory KinshipRespModel.fromJson(Map<String, dynamic> json) {
    return KinshipRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => KinshipModel.fromJson(e)).toList()
          : [],
    );
  }
}

class KinshipModel extends KinshipEntity {
  const KinshipModel({super.value, super.label});

  factory KinshipModel.fromJson(Map<String, dynamic> json) {
    return KinshipModel(value: json['value'], label: json['label']);
  }
}
