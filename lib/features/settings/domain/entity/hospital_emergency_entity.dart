import 'package:equatable/equatable.dart';

class HospitalEmergencyEntity extends Equatable {
  final int? id;
  final String? name;
  final String? number;
  final String? description;
  final String? location;
  final double? lat;
  final double? lng;
  final String? image;
  final List<String>? tags;

  const HospitalEmergencyEntity({
    this.id,
    this.name,
    this.number,
    this.description,
    this.location,
    this.lat,
    this.lng,
    this.image,
    this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        number,
        description,
        location,
        lat,
        lng,
        image,
        tags,
      ];
}
