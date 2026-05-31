import 'package:equatable/equatable.dart';

class QuickBookingParams extends Equatable {
  final String? doctorId;
  final String? appointmentDate;
  final String? firstName;
  final String? lastName;
  final String? countryCode;
  final String? phoneNumber;

  const QuickBookingParams({
    this.doctorId,
    this.appointmentDate,
    this.firstName,
    this.lastName,
    this.countryCode,
    this.phoneNumber,
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
  ];
}
