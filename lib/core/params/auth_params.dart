import 'package:equatable/equatable.dart';

class AuthParams extends Equatable {
  final bool? isMyProfile;
  final int? userId;
  final String? countryCode;
  final String? password;
  final String? passwordConfirmation;
  final String? name;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? commercialNumber;
  final String? shopName;
  final String? governmentId;
  final String? cityId;
  final String? shopAddress;
  final String? gender;
  final String? latitude;
  final String? longitude;
  final String? authType;
  final String? representCode;
  final String? imageUrl;
  final String? whatsapp;
  final String? bio;
  final String? token;
  final String? userType;
  final int? passwordResetId;
  final int? pendingUserId;
  final String? otp;
  final String? otpType;
  final String? fcmDeviceToken;
  final String? smsType;
  final String? registerType;

  const AuthParams({
    this.isMyProfile,
    this.userId,
    this.countryCode,
    this.password,
    this.passwordConfirmation,
    this.name,
    this.lastName,
    this.email,
    this.phone,
    this.token,
    this.userType,
    this.otp,
    this.passwordResetId,
    this.pendingUserId,
    this.fcmDeviceToken,
    this.commercialNumber,
    this.shopName,
    this.governmentId,
    this.cityId,
    this.shopAddress,
    this.imageUrl,
    this.whatsapp,
    this.bio,
    this.gender,
    this.latitude,
    this.longitude,
    this.authType,
    this.otpType,
    this.representCode,
    this.smsType,
    this.registerType,
  });

  @override
  List<Object?> get props => <Object?>[
    isMyProfile,
    userId,
    countryCode,
    password,
    passwordConfirmation,
    name,
    lastName,
    email,
    phone,
    token,
    userType,
    otp,
    passwordResetId,
    pendingUserId,
    fcmDeviceToken,
    commercialNumber,
    imageUrl,
    whatsapp,
    bio,
    shopName,
    governmentId,
    cityId,
    shopAddress,
    gender,
    latitude,
    longitude,
    authType,
    otpType,
    representCode,
    smsType,
    registerType,
  ];

  Map<String, dynamic> toJson() => {
    'country_code': countryCode,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'phone': phone,
    'last_name': lastName,
    "name": name,
    "email": email,
    "fcm_device_key": token,
    "user_type": userType,
    "password_reset_id": passwordResetId,
    "pending_user_id": pendingUserId,
    "otp": otp,
    "fcm_device_token": fcmDeviceToken,
    "commerical_number": commercialNumber,
    "shop_name": shopName,
    "government_id": governmentId,
    "city_id": cityId,
    "image": imageUrl,
    "shop_address": shopAddress,
    "gender": gender,
    "latitude": latitude,
    "longitude": longitude,
    "auth_type": authType,
    "otp_type": otpType,
    "represent_code": representCode,
    "sms_type": smsType,
  };
}
