import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/booking/domain/entities/appointment_booking_entity.dart';

class AppointmentBookingRespModel extends BaseOneResponse {
  const AppointmentBookingRespModel({super.status, super.message, super.data});

  factory AppointmentBookingRespModel.fromJson(Map<String, dynamic> json) {
    return AppointmentBookingRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? AppointmentBookingModel.fromJson(json['data'])
          : null,
    );
  }
}

class AppointmentBookingModel extends AppointmentBookingEntity {
  const AppointmentBookingModel({
    super.id,
    super.appointmentDate,
    super.status,
    super.createdAt,
  });

  factory AppointmentBookingModel.fromJson(Map<String, dynamic> json) {
    return AppointmentBookingModel(
      id: json['id'],
      appointmentDate: json['appointment_date'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
