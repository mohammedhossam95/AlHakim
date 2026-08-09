class AuthenticateParams {
  final String countryCode;
  final String phoneNumber;
  final String password;

  const AuthenticateParams({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'country_code': countryCode,
    'phone_number': phoneNumber,
    'password': password,
  };

  AuthenticateParams copyWith({
    String? countryCode,
    String? phoneNumber,
    String? password,
  }) {
    return AuthenticateParams(
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }
}
