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
        logo,
        cover,
        license,
      ];
}
