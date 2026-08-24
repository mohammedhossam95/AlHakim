class RegisterParams {
  final String countryCode;
  final String phoneNumber;
  final String password;
  final String passwordConfirmation;
  final String firstName;
  final String lastName;
  final String? birthDate;
  final String firebaseToken;

  const RegisterParams({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
    required this.firstName,
    required this.lastName,
    this.birthDate,
    required this.firebaseToken,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'country_code': countryCode,
      'phone_number': phoneNumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'first_name': firstName,
      'last_name': lastName,
      'device_token': firebaseToken,
    };

    if (birthDate != null && birthDate!.trim().isNotEmpty) {
      map['birth_date'] = birthDate!.trim();
    }

    return map;
  }

  RegisterParams copyWith({
    String? countryCode,
    String? phoneNumber,
    String? password,
    String? passwordConfirmation,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? firebaseToken,
  }) {
    return RegisterParams(
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      firebaseToken: firebaseToken ?? this.firebaseToken,
    );
  }
}
