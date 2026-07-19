import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/queue_management/domain/entities/queue_management_entity.dart';

class QueueManagementRespModel extends BaseListResponse {
  const QueueManagementRespModel({super.status, super.message, super.data});

  factory QueueManagementRespModel.fromJson(Map<String, dynamic> json) {
    return QueueManagementRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => QueueManagementModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class QueueManagementModel extends QueueManagementEntity {
  const QueueManagementModel({
    super.id,
    super.appointmentDate,
    super.status,
    super.queuePosition,
    super.isCurrent,
    super.bookedBy,
    super.patient,
    super.createdAt,
  });

  factory QueueManagementModel.fromJson(Map<String, dynamic> json) {
    return QueueManagementModel(
      id: json['id'],
      appointmentDate: json['appointment_date'],
      status: json['status'],
      queuePosition: json['queue_position']?.toString(),
      isCurrent: json['is_current'],

      bookedBy: json['booked_by'] != null
          ? QueueUserModel.fromJson(json['booked_by'])
          : null,

      patient: json['patient'] != null
          ? QueueUserModel.fromJson(json['patient'])
          : null,

      createdAt: json['created_at'],
    );
  }
}

class QueueUserModel extends QueueUserEntity {
  const QueueUserModel({
    super.id,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    super.countryCode,
    super.fullName,
    super.birthDate,
    super.kinship,
  });

  factory QueueUserModel.fromJson(Map<String, dynamic> json) {
    return QueueUserModel(
      id: json['id'],
      firstName: json['first_name'],

      lastName: json['last_name'],

      phoneNumber: json['phone_number'],
      countryCode: json['country_code'],
      fullName: json['full_name'],
      birthDate: json['birth_date'],
      kinship: json['kinship'] != null
          ? KinshipModel.fromJson(json['kinship'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'country_code': countryCode,
      'full_name': fullName,
      'birth_date': birthDate,
      'kinship': kinship != null ? (kinship as KinshipModel).toJson() : null,
    };
  }
}

class KinshipModel extends KinshipEntity {
  const KinshipModel({super.value, super.label});

  factory KinshipModel.fromJson(Map<String, dynamic> json) {
    return KinshipModel(value: json['value'], label: json['label']);
  }
  Map<String, dynamic> toJson() {
    return {'value': value, 'label': label};
  }
}
