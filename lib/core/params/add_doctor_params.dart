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
  final String? secretaryCountryCode;

  final String? minPatients;
  final String? representativeCode;
  final String? price;
  final String? consultationPrice;

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
    this.representativeCode,
    this.price,
    this.consultationPrice,
    this.profileImage,
    this.license,
    this.schedules,
    this.clinicCountryCode,
    this.secretaryCountryCode,
    this.hidePrice,
    this.hideConsultationPrice,
    this.medicalCenterId,
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
    representativeCode,
    price,
    consultationPrice,
    profileImage,
    license,
    schedules,
    clinicCountryCode,
    secretaryCountryCode,
    hidePrice,
    hideConsultationPrice,
    medicalCenterId,
  ];
}
