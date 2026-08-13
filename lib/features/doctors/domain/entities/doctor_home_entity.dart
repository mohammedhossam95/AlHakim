import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:equatable/equatable.dart';

class DoctorHomeEntity extends Equatable {
  final bool? isClinicOpen;
  final bool? doctorClosedToday;
  final DoctorEntity? doctor;
  final DoctorStatisticsEntity? statistics;

  const DoctorHomeEntity({
    this.isClinicOpen,
    this.doctorClosedToday,
    this.doctor,
    this.statistics,
  });

  @override
  List<Object?> get props => [
    isClinicOpen,
    doctorClosedToday,
    doctor,
    statistics,
  ];
}

class DoctorStatisticsEntity extends Equatable {
  final String? todayAppointmentsCount;

  final String? todayArrivedCount;

  final String? todayEnteredCount;

  final String? upcomingAppointmentsCount;

  const DoctorStatisticsEntity({
    this.todayAppointmentsCount,
    this.todayArrivedCount,
    this.todayEnteredCount,
    this.upcomingAppointmentsCount,
  });

  @override
  List<Object?> get props => [
    todayAppointmentsCount,
    todayArrivedCount,
    todayEnteredCount,
    upcomingAppointmentsCount,
  ];
}
