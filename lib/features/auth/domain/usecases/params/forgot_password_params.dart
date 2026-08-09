class ForgotPasswordParams {
  final String countryCode;
  final String phoneNumber;

  const ForgotPasswordParams({
    required this.countryCode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'country_code': countryCode,
    'phone_number': phoneNumber,
  };

  ForgotPasswordParams copyWith({
    String? countryCode,
    String? phoneNumber,
  }) {
    return ForgotPasswordParams(
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
