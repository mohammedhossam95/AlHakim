import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';
import 'package:alhakim/features/booking/data/models/appointment_type_model.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';
import 'package:alhakim/features/queue_management/data/models/queue_management_model.dart';

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
    super.appointmentType,
    super.appointmentTypeText,
    super.status,
    super.doctor,
    super.createdAt,
    super.bookedBy,
    super.patient,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      appointmentDate: json['appointment_date'],
      appointmentType: json['appointment_type'] != null
          ? AppointmentTypeModel.fromJson(json['appointment_type'])
          : null,
      appointmentTypeText: json['appointment_type_text'],
      status: json['status'],
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      createdAt: json['created_at'],
      bookedBy: json['booked_by'] != null
          ? QueueUserModel.fromJson(json['booked_by'])
          : null,
      patient: json['patient'] != null
          ? QueueUserModel.fromJson(json['patient'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_date': appointmentDate,
      'appointment_type': appointmentType,
      'appointment_type_text': appointmentTypeText,
      'status': status,
      'doctor': (doctor as DoctorModel?)?.toJson(),
      'created_at': createdAt,
    };
  }
}
