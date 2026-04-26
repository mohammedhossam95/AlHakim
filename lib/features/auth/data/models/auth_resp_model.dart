import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';

class AuthRespModel extends BaseOneResponse {
  const AuthRespModel({super.data, super.success, super.message});

  factory AuthRespModel.fromJson(Map<String, dynamic> json) => AuthRespModel(
    data: json["data"] == null ? null : AuthModel.fromJson(json["data"]),
    success: json["success"],
    message: (json['message'] != null) ? json["message"] : null,
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "success": success,
    "message": message,
  };
}

class AuthModel extends AuthEntity {
  const AuthModel({super.user, super.token});
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: json["data"] == null ? null : UserModel.fromJson(json["data"]),
      token: json['token'] ?? json['token'],
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.name,
    super.lastName,
    super.shopName,
    super.phone,
    super.phone2,
    super.fcmDeviceToken,
    super.email,
    super.government,
    super.city,
    super.shopAddress,
    super.gender,
    super.bio,
    super.countryCode,
    super.whatsapp,
    super.photo,
    super.coverPhoto,
    super.commercialNumber,
    super.address,
    super.latitude,
    super.longitude,
    super.authType,
    super.createdAt,
    super.updatedAt,
    super.accountType,
    super.token,
    super.active,
    super.emailVerifiedAt,
    super.emailTo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      shopName: json['shop_name'],
      phone: json['phone'],
      phone2: json['phone_2'],
      fcmDeviceToken: json['fcm_device_token'],
      email: json['email'],
      government: json['government'] != null
          ? GovernmentModel.fromJson(json['government'])
          : null,
      city: json['city'] != null ? CityModel.fromJson(json['city']) : null,
      shopAddress: json['shop_address'],
      gender: json['gender'],
      bio: json['bio'],
      countryCode: json['country_code'],
      whatsapp: json['whatsapp'],
      photo: json['photo'],
      coverPhoto: json['cover_photo'],
      commercialNumber: json['commerical_number'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      authType: json['auth_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      accountType: json['account_type'],
      token: json['token'],
      active: json['active'],
      emailVerifiedAt: json['email_verified_at'],
      emailTo: json['email_to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'shop_name': shopName,
      'phone': phone,
      'phone_2': phone2,
      'fcm_device_token': fcmDeviceToken,
      'email': email,
      'government': government != null
          ? (government as GovernmentModel).toJson()
          : null,
      'city': city != null ? (city as CityModel).toJson() : null,
      'shop_address': shopAddress,
      'gender': gender,
      'bio': bio,
      'country_code': countryCode,
      'whatsapp': whatsapp,
      'photo': photo,
      'cover_photo': coverPhoto,
      'commerical_number': commercialNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'auth_type': authType,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'account_type': accountType,
      'token': token,
      'active': active,
      'email_verified_at': emailVerifiedAt,
      'email_to': emailTo,
    };
  }
}

class GovernmentModel extends GovernmentEntity {
  const GovernmentModel({super.id, super.name});

  factory GovernmentModel.fromJson(Map<String, dynamic> json) {
    return GovernmentModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class CityModel extends CityEntity {
  const CityModel({super.id, super.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
