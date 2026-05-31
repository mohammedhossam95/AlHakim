import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? token;
  final UserEntity? user;
  final DoctorEntity? doctor;

  const AuthEntity({this.token, this.user, this.doctor});

  @override
  List<Object?> get props => [token, user, doctor];
}

class UserEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? countryCode;
  final String? birthDate;
  final bool? isPhoneVerified;
  final String? profilePhotoUrl;
  final String? referralCode;

  const UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.countryCode,
    this.birthDate,
    this.isPhoneVerified,
    this.profilePhotoUrl,
    this.referralCode,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    phoneNumber,
    countryCode,
    birthDate,
    isPhoneVerified,
    profilePhotoUrl,
    referralCode,
  ];
}
