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

  final File? profileImage;
  final File? license;
  final List<dynamic>? schedules;

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
    this.profileImage,
    this.license,
    this.schedules,
    this.clinicCountryCode,
    this.secretaryCountryCode,
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
    profileImage,
    license,
    schedules,
    clinicCountryCode,
    secretaryCountryCode,
  ];
}
