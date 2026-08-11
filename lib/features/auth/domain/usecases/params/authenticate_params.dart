class AuthenticateParams {
  final String countryCode;
  final String phoneNumber;
  final String password;
  final String firebaseToken;

  const AuthenticateParams({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
    required this.firebaseToken,
  });

  Map<String, dynamic> toJson() => {
    'country_code': countryCode,
    'phone_number': phoneNumber,
    'password': password,
    'device_token': firebaseToken,
  };

  AuthenticateParams copyWith({
    String? countryCode,
    String? phoneNumber,
    String? password,
    String? firebaseToken,
  }) {
    return AuthenticateParams(
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      firebaseToken: firebaseToken ?? this.firebaseToken,
    );
  }
}
