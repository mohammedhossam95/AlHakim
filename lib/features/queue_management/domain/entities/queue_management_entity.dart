import 'package:equatable/equatable.dart';

class QueueManagementEntity extends Equatable {
  final int? id;
  final String? appointmentDate;
  final String? status;
  final String? queuePosition;
  final bool? isCurrent;
  final QueueUserEntity? bookedBy;
  final QueueUserEntity? patient;
  final String? createdAt;

  const QueueManagementEntity({
    this.id,
    this.appointmentDate,
    this.status,
    this.queuePosition,
    this.isCurrent,
    this.bookedBy,
    this.patient,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    appointmentDate,
    status,
    queuePosition,
    isCurrent,
    bookedBy,
    patient,
    createdAt,
  ];
}

class QueueUserEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? countryCode;

  const QueueUserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.countryCode,
  });

  String get fullName => "${firstName ?? ''} ${lastName ?? ''}";

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    phoneNumber,
    countryCode,
  ];
}
