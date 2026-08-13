import 'package:alhakim/features/booking/domain/entities/appointment_type_entity.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/queue_management/domain/entities/queue_management_entity.dart';
import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int? id;
  final String? appointmentDate;
  final AppointmentTypeEntity? appointmentType;
  final String? appointmentTypeText;
  final String? status;
  final DoctorEntity? doctor;
  final String? createdAt;
   final QueueUserEntity? bookedBy;
  final QueueUserEntity? patient;

  const AppointmentEntity({
    this.id,
    this.appointmentDate,
    this.appointmentType,
    this.appointmentTypeText,
    this.status,
    this.doctor,
    this.createdAt,
    this.bookedBy,
    this.patient,
  });

  @override
  List<Object?> get props => [
    id,
    appointmentDate,
    appointmentType,
    appointmentTypeText,
    status,
    doctor,
    createdAt,
    bookedBy,
    patient,
  ];
}
