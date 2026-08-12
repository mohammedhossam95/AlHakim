import 'package:equatable/equatable.dart';

class MedicalCenterEntity extends Equatable {
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
  final String? createdAt;
  final String? latitude;
  final String? longitude;
  final String? city;
  final String? district;
  final String? street;

  const MedicalCenterEntity({
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
    this.createdAt,
    this.latitude,
    this.longitude,
    this.city,
    this.district,
    this.street,
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
    createdAt,
    latitude,
    longitude,
    city,
    district,
    street,
  ];
}
