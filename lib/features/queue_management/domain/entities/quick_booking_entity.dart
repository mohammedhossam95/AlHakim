import 'package:equatable/equatable.dart';

class QuickBookingEntity extends Equatable {
  final int? id;
  final String? appointmentDate;
  final String? status;
  final int? queuePosition;
  final bool? isCurrent;
  final String? createdAt;

  const QuickBookingEntity({
    this.id,
    this.appointmentDate,
    this.status,
    this.queuePosition,
    this.isCurrent,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    appointmentDate,
    status,
    queuePosition,
    isCurrent,
    createdAt,
  ];
}
