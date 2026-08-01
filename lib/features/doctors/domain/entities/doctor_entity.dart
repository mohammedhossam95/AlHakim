import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String? id;
  final NameEntity? name;
  final BioEntity? bio;
  final String? price;
  final RatingEntity? rating;
  final bool? isActive;
  final bool? isClinicOpen;
  final LocationEntity? location;
  final String? professionalRegistrationNumber;
  final String? academicDegree;
  final String? clinicPhone;
  final String? secretaryPhone;
  final String? secretaryCountryCode;
  final String? profileImage;
  final dynamic distanceKm;
  final List<LanguageEntity>? languages;
  final DoctorSpecialtyEntity? specialty;
  final List<ScheduleEntity>? schedules;
  final String? createdAt;
  final String? updatedAt;
  final String? minPatients;
  final String? representativeCode;
  final bool? priceHidden;
  final String? consultationPrice;
  final bool? consultationPriceHidden;
  final MedicalCenter? medicalCenter;
  final String? whatsappNumber;
  final String? whatsappCountryCode;
  final String? latitude;
  final String? longitude;

  const DoctorEntity({
    this.id,
    this.name,
    this.bio,
    this.price,
    this.rating,
    this.isActive,
    this.isClinicOpen,
    this.location,
    this.professionalRegistrationNumber,
    this.academicDegree,
    this.clinicPhone,
    this.secretaryPhone,
    this.profileImage,
    this.distanceKm,
    this.languages,
    this.specialty,
    this.schedules,
    this.createdAt,
    this.updatedAt,
    this.minPatients,
    this.representativeCode,
    this.priceHidden,
    this.secretaryCountryCode,
    this.consultationPrice,
    this.consultationPriceHidden,
    this.medicalCenter,
    this.whatsappNumber,
    this.whatsappCountryCode,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    bio,
    price,
    rating,
    isActive,
    isClinicOpen,
    location,
    professionalRegistrationNumber,
    academicDegree,
    clinicPhone,
    secretaryPhone,
    profileImage,
    distanceKm,
    languages,
    specialty,
    schedules,
    createdAt,
    updatedAt,
    minPatients,
    representativeCode,
    priceHidden,
    secretaryCountryCode,
    consultationPrice,
    consultationPriceHidden,
    medicalCenter,
    whatsappNumber,
    whatsappCountryCode,
    latitude,
    longitude,
  ];
}

class NameEntity extends Equatable {
  final String? en;
  final String? ar;

  const NameEntity({this.en, this.ar});

  @override
  List<Object?> get props => [en, ar];
}

class BioEntity extends Equatable {
  final String? en;
  final String? ar;

  const BioEntity({this.en, this.ar});

  @override
  List<Object?> get props => [en, ar];
}

class RatingEntity extends Equatable {
  final String? average;
  final int? count;

  const RatingEntity({this.average, this.count});

  @override
  List<Object?> get props => [average, count];
}

class LocationEntity extends Equatable {
  final String? city;
  final String? district;
  final String? street;
  final String? latitude;
  final String? longitude;

  const LocationEntity({
    this.city,
    this.district,
    this.street,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [city, district, street, latitude, longitude];
}

class LanguageEntity extends Equatable {
  final int? id;
  final String? code;
  final String? name;

  const LanguageEntity({this.id, this.code, this.name});

  @override
  List<Object?> get props => [id, code, name];
}

class DoctorSpecialtyEntity extends Equatable {
  final int? id;
  final String? icon;
  final int? isActive;
  final int? sortOrder;
  final String? name;
  final String? slug;
  final bool? hasChildren;
  final int? doctorsCount;
  final String? createdAt;
  final String? updatedAt;

  const DoctorSpecialtyEntity({
    this.id,
    this.icon,
    this.isActive,
    this.sortOrder,
    this.name,
    this.slug,
    this.hasChildren,
    this.doctorsCount,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    icon,
    isActive,
    sortOrder,
    name,
    slug,
    hasChildren,
    doctorsCount,
    createdAt,
    updatedAt,
  ];
}

class ScheduleEntity extends Equatable {
  final int? id;
  final int? dayOfWeek;
  final String? dayName;
  final String? startTime;
  final String? endTime;
  final int? slotDuration;

  const ScheduleEntity({
    this.id,
    this.dayOfWeek,
    this.dayName,
    this.startTime,
    this.endTime,
    this.slotDuration,
  });

  @override
  List<Object?> get props => [
    id,
    dayOfWeek,
    dayName,
    startTime,
    endTime,
    slotDuration,
  ];
}

class MedicalCenter extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final String? address;
  final String? countryCode;
  final String? phone;
  final String? email;
  final String? logo;
  final String? cover;
  final bool? isActive;
  final String? latitude;
  final String? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MedicalCenter({
    this.id,
    this.name,
    this.description,
    this.address,
    this.countryCode,
    this.phone,
    this.email,
    this.logo,
    this.cover,
    this.isActive,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    address,
    countryCode,
    phone,
    email,
    logo,
    cover,
    isActive,
    latitude,
    longitude,
    createdAt,
    updatedAt,
  ];
}
