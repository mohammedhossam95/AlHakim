import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/booking/domain/entities/family_member_entity.dart';

class FamilyMemberRespModel extends BaseListResponse {
  const FamilyMemberRespModel({super.status, super.message, super.data});

  factory FamilyMemberRespModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => FamilyMemberModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class AddFamilyMemberRespModel extends BaseOneResponse {
  const AddFamilyMemberRespModel({super.status, super.message, super.data});

  factory AddFamilyMemberRespModel.fromJson(Map<String, dynamic> json) {
    return AddFamilyMemberRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? FamilyMemberModel.fromJson(json['data'])
          : null,
    );
  }
}

class FamilyMemberModel extends FamilyMemberEntity {
  const FamilyMemberModel({
    super.id,
    super.fullName,
    super.birthDate,
    super.kinship,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'],
      fullName: json['full_name'],
      birthDate: json['birth_date'],
      kinship: json['kinship'] != null
          ? KinshipDataModel.fromJson(json['kinship'])
          : null,
    );
  }
}

class KinshipDataModel extends KinshipDataEntity {
  const KinshipDataModel({super.value, super.label});

  factory KinshipDataModel.fromJson(Map<String, dynamic> json) {
    return KinshipDataModel(value: json['value'], label: json['label']);
  }
}
