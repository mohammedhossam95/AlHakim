import 'package:alhakim/features/booking/domain/entities/appointment_type_entity.dart';
import 'package:equatable/equatable.dart';

class AppointmentBookingEntity extends Equatable {
  final int? id;
  final String? appointmentDate;
  final String? status;
  final String? createdAt;
  final AppointmentTypeEntity? appointmentType;
  final int? queuePosition;

  const AppointmentBookingEntity({
    this.id,
    this.appointmentDate,
    this.status,
    this.createdAt,
    this.appointmentType,
    this.queuePosition,
  });

  @override
  List<Object?> get props => [
    id,
    appointmentDate,
    status,
    createdAt,
    appointmentType,
    queuePosition,
  ];
}
