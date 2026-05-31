import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final int? id;
  final String? appointmentDate;
  final String? status;
  final AppointmentDoctorEntity? doctor;
  final String? createdAt;

  const AppointmentEntity({
    this.id,
    this.appointmentDate,
    this.status,
    this.doctor,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        appointmentDate,
        status,
        doctor,
        createdAt,
      ];
}

class AppointmentDoctorEntity
    extends Equatable {
  final String? id;
  final String? name;
  final String? price;
  final AppointmentRatingEntity? rating;
  final String? city;
  final String? clinicPhone;
  final String? profileImage;
  final bool? isActive;
  final AppointmentSpecialtyEntity?
      specialty;

  const AppointmentDoctorEntity({
    this.id,
    this.name,
    this.price,
    this.rating,
    this.city,
    this.clinicPhone,
    this.profileImage,
    this.isActive,
    this.specialty,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        rating,
        city,
        clinicPhone,
        profileImage,
        isActive,
        specialty,
      ];
}

class AppointmentRatingEntity
    extends Equatable {
  final String? average;
  final int? count;

  const AppointmentRatingEntity({
    this.average,
    this.count,
  });

  @override
  List<Object?> get props => [
        average,
        count,
      ];
}

class AppointmentSpecialtyEntity
    extends Equatable {
  final int? id;
  final String? icon;
  final String? isActive;
  final String? sortOrder;
  final String? name;
  final String? slug;
  final bool? hasChildren;
  final int? doctorsCount;
  final String? createdAt;
  final String? updatedAt;

  const AppointmentSpecialtyEntity({
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