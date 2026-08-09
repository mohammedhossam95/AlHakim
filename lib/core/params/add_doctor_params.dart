import 'dart:io';

import 'package:equatable/equatable.dart';

class AddDoctorParams extends Equatable {
  final String? id;
  final String? nameAr;
  final String? bioAr;

  final String? nameEn;
  final String? bioEn;

  final int? specialtyId;

  final String? professionalRegistrationNumber;
  final String? academicDegree;

  final String? clinicPhone;
  final String? clinicCountryCode;

  final String? secretaryPhone;
  final String? whatsappNumber;
  final String? whatsappCountryCode;
  final String? secretaryCountryCode;

  final String? minPatients;
  final String? appointmentDaysNumber;
  final List<int>? appointmentTypeIds;
  final String? representativeCode;
  final String? price;
  final String? consultationPrice;
  final String? latitude;
  final String? longitude;
  final String? city;
  final String? district;
  final String? street;

  final String? password;
  final String? passwordConfirmation;

  final File? profileImage;
  final File? license;
  final List<dynamic>? schedules;
  final bool? hidePrice;
  final bool? hideConsultationPrice;
  final int? medicalCenterId;

  const AddDoctorParams({
    this.id,
    this.nameAr,
    this.bioAr,
    this.nameEn,
    this.bioEn,
    this.specialtyId,
    this.professionalRegistrationNumber,
    this.academicDegree,
    this.clinicPhone,
    this.secretaryPhone,
    this.minPatients,
    this.appointmentDaysNumber,
    this.appointmentTypeIds,
    this.representativeCode,
    this.price,
    this.consultationPrice,
    this.password,
    this.passwordConfirmation,
    this.profileImage,
    this.license,
    this.schedules,
    this.clinicCountryCode,
    this.secretaryCountryCode,
    this.hidePrice,
    this.hideConsultationPrice,
    this.medicalCenterId,
    this.whatsappNumber,
    this.whatsappCountryCode,
    this.latitude,
    this.longitude,
    this.city,
    this.district,
    this.street,
  });

  @override
  List<Object?> get props => [
    id,
    nameAr,
    bioAr,
    nameEn,
    bioEn,
    specialtyId,
    professionalRegistrationNumber,
    academicDegree,
    clinicPhone,
    secretaryPhone,
    minPatients,
    appointmentDaysNumber,
    appointmentTypeIds,
    representativeCode,
    price,
    consultationPrice,
    password,
    passwordConfirmation,
    profileImage,
    license,
    schedules,
    clinicCountryCode,
    secretaryCountryCode,
    hidePrice,
    hideConsultationPrice,
    medicalCenterId,
    whatsappNumber,
    whatsappCountryCode,
    latitude,
    longitude,
    city,
    district,
    street,
  ];
}
