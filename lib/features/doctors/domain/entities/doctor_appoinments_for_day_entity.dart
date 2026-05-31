import 'package:equatable/equatable.dart';

class DoctorAppoinmentsForDayEntity extends Equatable {
  final int? id;
  final String? appointmentDate;
  final String? status;
  final String? queuePosition;
  final bool? isCurrent;
  final DoctorAppoinmentsForDayUserEntity? bookedBy;
  final String? createdAt;

  const DoctorAppoinmentsForDayEntity({
    this.id,
    this.appointmentDate,
    this.status,
    this.queuePosition,
    this.isCurrent,
    this.bookedBy,
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
    createdAt,
  ];
}

class DoctorAppoinmentsForDayUserEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? countryCode;

  const DoctorAppoinmentsForDayUserEntity({
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
