import 'package:equatable/equatable.dart';

class CompleteProfileParams extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? tall;
  final String? weight;
  final String? bloodType;
  final String? location;

  const CompleteProfileParams({
    this.firstName,
    this.lastName,
    this.birthDate,
    this.tall,
    this.weight,
    this.bloodType,
    this.location,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (firstName != null) {
      data['first_name'] = firstName;
    }

    if (lastName != null) {
      data['last_name'] = lastName;
    }

    if (birthDate != null) {
      data['birth_date'] = birthDate;
    }

    if (tall != null) {
      data['tall'] = tall;
    }

    if (weight != null) {
      data['weight'] = weight;
    }

    if (bloodType != null) {
      data['blood_type'] = bloodType;
    }

    if (location != null) {
      data['location'] = location;
    }

    return data;
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    birthDate,
    tall,
    weight,
    bloodType,
    location,
  ];
}
