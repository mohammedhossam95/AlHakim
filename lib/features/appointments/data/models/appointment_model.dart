import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';

class AppointmentRespModel extends BaseListResponse {
  const AppointmentRespModel({super.status, super.message, super.data});

  factory AppointmentRespModel.fromJson(Map<String, dynamic> json) {
    return AppointmentRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => AppointmentModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    super.id,
    super.appointmentDate,
    super.status,
    super.doctor,
    super.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      appointmentDate: json['appointment_date'],
      status: json['status'],
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      createdAt: json['created_at'],
    );
  }
}
