import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_appoinments_for_day_entity.dart';

class DoctorAppoinmentsForDayRespModel extends BaseListResponse {
  const DoctorAppoinmentsForDayRespModel({
    super.status,
    super.message,
    super.data,
  });

  factory DoctorAppoinmentsForDayRespModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppoinmentsForDayRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => DoctorAppoinmentsForDayModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class DoctorAppoinmentsForDayModel extends DoctorAppoinmentsForDayEntity {
  const DoctorAppoinmentsForDayModel({
    super.id,
    super.appointmentDate,
    super.status,
    super.queuePosition,
    super.isCurrent,
    super.bookedBy,
    super.createdAt,
  });

  factory DoctorAppoinmentsForDayModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppoinmentsForDayModel(
      id: json['id'],
      appointmentDate: json['appointment_date'],
      status: json['status'],
      queuePosition: json['queue_position']?.toString(),
      isCurrent: json['is_current'],

      bookedBy: json['booked_by'] != null
          ? DoctorAppoinmentsForDayUserModel.fromJson(json['booked_by'])
          : null,

      createdAt: json['created_at'],
    );
  }
}

class DoctorAppoinmentsForDayUserModel
    extends DoctorAppoinmentsForDayUserEntity {
  const DoctorAppoinmentsForDayUserModel({
    super.id,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    super.countryCode,
  });

  factory DoctorAppoinmentsForDayUserModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppoinmentsForDayUserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      countryCode: json['country_code'],
    );
  }
}
