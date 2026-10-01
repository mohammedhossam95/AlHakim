import 'package:equatable/equatable.dart';

class QuickBookingParams extends Equatable {
  final String? doctorId;
  final String? appointmentDate;
  final String? firstName;
  final String? lastName;
  final String? countryCode;
  final String? phoneNumber;
  final int? appointmentTypeId;

  const QuickBookingParams({
    this.doctorId,
    this.appointmentDate,
    this.firstName,
    this.lastName,
    this.countryCode,
    this.phoneNumber,
    this.appointmentTypeId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (doctorId != null) {
      data['doctor_id'] = doctorId;
    }

    if (appointmentDate != null) {
      data['appointment_date'] = appointmentDate;
    }

    if (firstName != null) {
      data['first_name'] = firstName;
    }

    if (lastName != null) {
      data['last_name'] = lastName;
    }

    if (countryCode != null) {
      data['country_code'] = countryCode;
    }

    if (phoneNumber != null) {
      data['phone_number'] = phoneNumber;
    }

    if (appointmentTypeId != null) {
      data['appointment_type_id'] = appointmentTypeId;
    }

    return data;
  }

  @override
  List<Object?> get props => [
    doctorId,
    appointmentDate,
    firstName,
    lastName,
    countryCode,
    phoneNumber,
    appointmentTypeId,
  ];
}
