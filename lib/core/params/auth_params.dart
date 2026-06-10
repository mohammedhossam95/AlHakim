import 'package:alhakim/core/utils/enums.dart';
import 'package:equatable/equatable.dart';

class AuthParams extends Equatable {
  final String? countryCode;
  final String? phoneNumber;
  final String? otp;
  final UserType? userType;
  final String? secretaryPhone;
  final String? secretaryCountryCode;
  final String? firebaseToken;

  const AuthParams({
    this.countryCode,
    this.phoneNumber,
    this.otp,
    this.userType,
    this.secretaryPhone,
    this.secretaryCountryCode,
    this.firebaseToken,
  });

  @override
  List<Object?> get props => [
    countryCode,
    phoneNumber,
    otp,
    userType,
    secretaryPhone,
    secretaryCountryCode,
    firebaseToken,
  ];

  Map<String, dynamic> toJson() => {
    "country_code": countryCode,
    "phone_number": phoneNumber,
    "otp": otp,
    "secretary_phone": secretaryPhone,
    "secretary_country_code": secretaryCountryCode,
    "token": firebaseToken,
  };
}
