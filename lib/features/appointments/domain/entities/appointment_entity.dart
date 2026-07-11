import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int? id;
  final String? appointmentDate;
  final String? status;
  final DoctorEntity? doctor;
  final String? createdAt;

  const AppointmentEntity({
    this.id,
    this.appointmentDate,
    this.status,
    this.doctor,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, appointmentDate, status, doctor, createdAt];
}
