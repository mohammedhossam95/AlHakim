import 'package:equatable/equatable.dart';

class AppointmentBookingEntity
    extends Equatable {
  final int? id;
  final String? appointmentDate;
  final String? status;
  final String? createdAt;

  const AppointmentBookingEntity({
    this.id,
    this.appointmentDate,
    this.status,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        appointmentDate,
        status,
        createdAt,
      ];
}