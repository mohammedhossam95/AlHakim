import 'package:alhakim/features/doctors/data/models/doctor_model.dart';
import 'package:alhakim/features/doctors/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.id,
    super.name,
    super.description,
    super.address,
    super.location,
    super.countryCode,
    super.phone,
    super.email,
    super.logo,
    super.cover,
    super.isActive,
    super.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"]?.toString(),
    name: json["name"],
    description: json["description"],
    address: json["address"],
    location: json["location"] == null
        ? null
        : LocationModel.fromJson(json["location"]),
    countryCode: json["country_code"],
    phone: json["phone"],
    email: json["email"],
    logo: json["logo"],
    cover: json["cover"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "address": address,
    "location": location is LocationModel
        ? (location as LocationModel).toJson()
        : location == null
        ? null
        : {
            "city": location?.city,
            "district": location?.district,
            "street": location?.street,
            "latitude": location?.latitude,
            "longitude": location?.longitude,
          },
    "country_code": countryCode,
    "phone": phone,
    "email": email,
    "logo": logo,
    "cover": cover,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
  };
}
