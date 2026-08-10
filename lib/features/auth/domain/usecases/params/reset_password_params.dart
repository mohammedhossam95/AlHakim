class ResetPasswordParams {
  final String countryCode;
  final String phoneNumber;
  final String otp;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordParams({
    required this.countryCode,
    required this.phoneNumber,
    required this.otp,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    'country_code': countryCode,
    'phone_number': phoneNumber,
    'otp': otp,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };

  ResetPasswordParams copyWith({
    String? countryCode,
    String? phoneNumber,
    String? otp,
    String? password,
    String? passwordConfirmation,
  }) {
    return ResetPasswordParams(
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }
}
