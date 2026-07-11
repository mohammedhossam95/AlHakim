import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/features/auth/domain/entities/verify_otp_entity.dart';
import 'package:alhakim/features/doctors/data/models/doctor_model.dart';
import 'package:alhakim/features/doctors/data/models/profile_model.dart';

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
  const AuthModel({
    super.token,
    super.role,
    super.user,
    super.doctor,
    super.profile,
    super.nextStep,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final role = json['role'];

    return AuthModel(
      token: json['token'],
      role: role,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      doctor: role == 'doctor'
          ? _parseDoctorFromJson(json)
          : null,
      profile: role == 'medical_center' && json['profile'] != null
          ? ProfileModel.fromJson(json['profile'])
          : null,
      nextStep: json['next_step'],
    );
  }

  static DoctorModel? _parseDoctorFromJson(Map<String, dynamic> json) {
    // API returns doctor data under "profile"; local cache uses "doctor".
    final doctorJson = json['doctor'] ?? json['profile'];
    if (doctorJson == null) return null;
    return DoctorModel.fromJson(doctorJson);
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "role": role,
    "user": user is UserModel ? (user as UserModel).toJson() : null,
    "doctor": doctor is DoctorModel ? (doctor as DoctorModel).toJson() : null,
    "profile": profile is ProfileModel
        ? (profile as ProfileModel).toJson()
        : null,
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
    super.tall,
    super.weight,
    super.bloodType,
    super.location,
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
      tall: json['tall'],
      weight: json['weight'],
      bloodType: json['blood_type'],
      location: json['location'],
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
    "tall": tall,
    "weight": weight,
    "blood_type": bloodType,
    "location": location,
  };
}
