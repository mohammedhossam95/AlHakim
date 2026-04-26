import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? name;
  final String? lastName;
  final String? shopName;
  final String? phone;
  final String? phone2;
  final String? fcmDeviceToken;
  final String? email;

  final GovernmentEntity? government;
  final CityEntity? city;

  final String? shopAddress;
  final String? gender;
  final String? image;

  final String? latitude;
  final String? longitude;

  final String? authType;

  final String? createdAt;
  final String? updatedAt;

  final int? accountType;
  final String? token;
  final bool? active;

  final String? bio;
  final String? countryCode;
  final String? whatsapp;

  final String? photo;
  final String? coverPhoto;

  final String? commercialNumber;

  final String? address;

  /// 🔹 Added from new API response
  final String? emailVerifiedAt;
  final String? emailTo;

  const UserEntity({
    this.id,
    this.name,
    this.lastName,
    this.shopName,
    this.phone,
    this.phone2,
    this.fcmDeviceToken,
    this.email,
    this.government,
    this.city,
    this.shopAddress,
    this.gender,
    this.image,
    this.latitude,
    this.longitude,
    this.authType,
    this.createdAt,
    this.updatedAt,
    this.accountType,
    this.token,
    this.active,
    this.bio,
    this.countryCode,
    this.whatsapp,
    this.photo,
    this.coverPhoto,
    this.commercialNumber,
    this.address,
    this.emailVerifiedAt,
    this.emailTo,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        lastName,
        shopName,
        phone,
        phone2,
        fcmDeviceToken,
        email,
        government,
        city,
        shopAddress,
        gender,
        image,
        latitude,
        longitude,
        authType,
        createdAt,
        updatedAt,
        accountType,
        token,
        active,
        bio,
        countryCode,
        whatsapp,
        photo,
        coverPhoto,
        commercialNumber,
        address,
        emailVerifiedAt,
        emailTo,
      ];
}

class GovernmentEntity extends Equatable {
  final String? id;
  final String? name;

  const GovernmentEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}

class CityEntity extends Equatable {
  final int? id;
  final String? name;

  const CityEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}

class AuthEntity extends Equatable {
  final UserEntity? user;
  final String? token;

  const AuthEntity({this.user, this.token});

  @override
  List<Object?> get props => [user, token];
}