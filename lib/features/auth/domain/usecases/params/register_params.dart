class RegisterParams {
  final String countryCode;
  final String phoneNumber;
  final String password;
  final String passwordConfirmation;
  final String firstName;
  final String lastName;
  final String birthDate;

  const RegisterParams({
    required this.countryCode,
    required this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
    'country_code': countryCode,
    'phone_number': phoneNumber,
    'password': password,
    'password_confirmation': passwordConfirmation,
    'first_name': firstName,
    'last_name': lastName,
    'birth_date': birthDate,
  };

  RegisterParams copyWith({
    String? countryCode,
    String? phoneNumber,
    String? password,
    String? passwordConfirmation,
    String? firstName,
    String? lastName,
    String? birthDate,
  }) {
    return RegisterParams(
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
