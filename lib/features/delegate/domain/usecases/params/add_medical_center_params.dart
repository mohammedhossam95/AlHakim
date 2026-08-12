import 'dart:io';

import 'package:equatable/equatable.dart';

class AddMedicalCenterParams extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? address;
  final String? countryCode;
  final String? phone;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? latitude;
  final String? longitude;
  final String? city;
  final String? district;
  final String? street;
  final String? representativeCode;
  final File? logo;
  final File? cover;
  final File? license;

  const AddMedicalCenterParams({
    this.id,
    this.name,
    this.description,
    this.address,
    this.countryCode,
    this.phone,
    this.email,
    this.password,
    this.confirmPassword,
    this.latitude,
    this.longitude,
    this.city,
    this.district,
    this.street,
    this.representativeCode,
    this.logo,
    this.cover,
    this.license,
  });

  AddMedicalCenterParams copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? countryCode,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
    String? latitude,
    String? longitude,
    String? city,
    String? district,
    String? street,
    String? representativeCode,
    File? logo,
    File? cover,
    File? license,
  }) {
    return AddMedicalCenterParams(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      district: district ?? this.district,
      street: street ?? this.street,
      representativeCode: representativeCode ?? this.representativeCode,
      logo: logo ?? this.logo,
      cover: cover ?? this.cover,
      license: license ?? this.license,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    address,
    countryCode,
    phone,
    email,
    password,
    confirmPassword,
    latitude,
    longitude,
    city,
    district,
    street,
    representativeCode,
    logo,
    cover,
    license,
  ];
}
