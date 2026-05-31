import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/auth/domain/entities/verify_otp_entity.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';

class AuthRespModel extends BaseOneResponse {
  const AuthRespModel({super.status, super.message, super.data});

  factory AuthRespModel.fromJson(Map<String, dynamic> json) {
    return AuthRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? AuthModel.fromJson(json['data']) : null,
    );
  }
}

class AuthModel extends UserAuthEntity {
  const AuthModel({super.token, super.user, super.doctor, super.nextStep});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      nextStep: json['next_step'],
    );
  }
  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user is UserModel ? (user as UserModel).toJson() : null,
    "doctor": doctor is DoctorModel ? (doctor as DoctorModel).toJson() : null,
  };
}

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.firstName,
    super.lastName,
    super.phoneNumber,
    super.countryCode,
    super.birthDate,
    super.isPhoneVerified,
    super.profilePhotoUrl,
    super.referralCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      countryCode: json['country_code'],
      birthDate: json['birth_date'],
      isPhoneVerified: json['is_phone_verified'],
      profilePhotoUrl: json['profile_photo_url'],
      referralCode: json['referral_code'],
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone_number": phoneNumber,
    "country_code": countryCode,
    "birth_date": birthDate,
    "is_phone_verified": isPhoneVerified,
    "profile_photo_url": profilePhotoUrl,
    "referral_code": referralCode,
  };
}
