import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_home_entity.dart';

class DoctorHomeRespModel extends BaseOneResponse {
  const DoctorHomeRespModel({super.status, super.message, super.data});

  factory DoctorHomeRespModel.fromJson(Map<String, dynamic> json) {
    return DoctorHomeRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? DoctorHomeModel.fromJson(json['data'])
          : null,
    );
  }
}

class DoctorHomeModel extends DoctorHomeEntity {
  const DoctorHomeModel({
    super.isClinicOpen,
    super.doctorClosedToday,
    super.statistics,
  });

  factory DoctorHomeModel.fromJson(Map<String, dynamic> json) {
    return DoctorHomeModel(
      isClinicOpen: json['is_clinic_open'],
      doctorClosedToday: json['doctor_closed_today'],

      statistics: json['statistics'] != null
          ? DoctorStatisticsModel.fromJson(json['statistics'])
          : null,
    );
  }
}

class DoctorStatisticsModel extends DoctorStatisticsEntity {
  const DoctorStatisticsModel({
    super.todayAppointmentsCount,
    super.todayArrivedCount,
    super.todayEnteredCount,
    super.upcomingAppointmentsCount,
  });

  factory DoctorStatisticsModel.fromJson(Map<String, dynamic> json) {
    return DoctorStatisticsModel(
      todayAppointmentsCount: json['today_appointments_count']?.toString(),

      todayArrivedCount: json['today_arrived_count']?.toString(),

      todayEnteredCount: json['today_entered_count']?.toString(),

      upcomingAppointmentsCount: json['upcoming_appointments_count']
          ?.toString(),
    );
  }
}
