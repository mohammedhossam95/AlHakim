import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';

class DoctorsRespModel extends BaseListResponse {
  const DoctorsRespModel({super.status, super.message, super.data});

  factory DoctorsRespModel.fromJson(Map<String, dynamic> json) {
    return DoctorsRespModel(
      status: json['status'],

      message: json['message'],

      data: _parseDoctorsList(json['data']),
    );
  }

  static List<DoctorModel> _parseDoctorsList(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => DoctorModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    if (raw is Map && raw['data'] is List) {
      return (raw['data'] as List)
          .whereType<Map>()
          .map((e) => DoctorModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    super.id,
    super.name,
    super.bio,
    super.price,
    super.rating,
    super.isActive,
    super.isClinicOpen,
    super.location,
    super.professionalRegistrationNumber,
    super.academicDegree,
    super.secretaryPhone,
    super.profileImage,
    super.distanceKm,
    super.languages,
    super.specialty,
    super.schedules,
    super.createdAt,
    super.updatedAt,
    super.minPatients,
    super.representativeCode,
    super.priceHidden,
    super.secretaryCountryCode,
    super.consultationPrice,
    super.consultationPriceHidden,
    super.medicalCenter,
    super.whatsappNumber,
    super.whatsappCountryCode,
    super.latitude,
    super.longitude,
    super.license,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] != null
        ? LocationModel.fromJson(json['location'])
        : null;
    return DoctorModel(
      id: json['id']?.toString(),

      name: NameModel.maybeFromJson(json['name']),

      bio: BioModel.maybeFromJson(json['bio']),

      price: json['price']?.toString(),
      priceHidden: json['price_hidden'],

      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,

      isActive: json['is_active'],
      isClinicOpen: json['is_clinic_open'],
      location: location,
      professionalRegistrationNumber: json['professional_registration_number'],
      academicDegree: json['academic_degree'],
      secretaryPhone: json['secretary_phone'],

      profileImage: json['profile_image'],

      distanceKm: json['distance_km'],

      languages: json['languages'] != null
          ? (json['languages'] as List)
                .map((e) => LanguageModel.fromJson(e))
                .toList()
          : [],

      specialty: json['specialty'] != null
          ? DoctorSpecialtyModel.fromJson(json['specialty'])
          : null,

      schedules: json['schedules'] != null
          ? (json['schedules'] as List)
                .map((e) => ScheduleModel.fromJson(e))
                .toList()
          : [],

      createdAt: json['created_at'],

      updatedAt: json['updated_at'],

      minPatients: json['min_patients']?.toString(),

      representativeCode: json['representative_code'],

      secretaryCountryCode: json['secretary_country_code'],
      consultationPrice: json['consultation_price']?.toString(),
      consultationPriceHidden: json['consultation_price_hidden'],

      medicalCenter: json['medical_center'] != null
          ? MedicalCenterModel.fromJson(json['medical_center'])
          : null,
      whatsappNumber: json['whatsapp_number'],
      whatsappCountryCode: json['whatsapp_country_code'],
      latitude: (json['latitude'] ?? location?.latitude)?.toString(),
      longitude: (json['longitude'] ?? location?.longitude)?.toString(),
      license: json['license']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,

    "name": name is NameModel ? (name as NameModel).toJson() : null,

    "bio": bio is BioModel ? (bio as BioModel).toJson() : null,

    "price": price,

    "rating": rating is RatingModel ? (rating as RatingModel).toJson() : null,

    "is_active": isActive,

    "is_clinic_open": isClinicOpen,

    "location": location is LocationModel
        ? (location as LocationModel).toJson()
        : null,

    "professional_registration_number": professionalRegistrationNumber,

    "academic_degree": academicDegree,
    "secretary_phone": secretaryPhone,
    "profile_image": profileImage,
    "distance_km": distanceKm,

    "languages": languages == null
        ? []
        : List<dynamic>.from(
            languages!.map((x) => (x as LanguageModel).toJson()),
          ),

    "specialty": specialty is DoctorSpecialtyModel
        ? (specialty as DoctorSpecialtyModel).toJson()
        : null,

    "schedules": schedules == null
        ? []
        : List<dynamic>.from(
            schedules!.map((x) => (x as ScheduleModel).toJson()),
          ),

    "created_at": createdAt,

    "updated_at": updatedAt,
    "price_hidden": priceHidden,
    "secretary_country_code": secretaryCountryCode,
    "whatsapp_number": whatsappNumber,
    "whatsapp_country_code": whatsappCountryCode,
    "latitude": latitude,
    "longitude": longitude,
    "license": license,
  };
}

class NameModel extends NameEntity {
  const NameModel({super.en, super.ar});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(en: json['en']?.toString(), ar: json['ar']?.toString());
  }

  static NameModel? maybeFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final text = value.trim();
      if (text.isEmpty) return null;
      return NameModel(en: text, ar: text);
    }
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return NameModel(
        en: (map['en'] ?? map['EN'] ?? map['english'])?.toString(),
        ar: (map['ar'] ?? map['AR'] ?? map['arabic'])?.toString(),
      );
    }
    return null;
  }

  Map<String, dynamic> toJson() => {"en": en, "ar": ar};
}

class BioModel extends BioEntity {
  const BioModel({super.en, super.ar});

  factory BioModel.fromJson(Map<String, dynamic> json) {
    return BioModel(en: json['en']?.toString(), ar: json['ar']?.toString());
  }

  static BioModel? maybeFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final text = value.trim();
      if (text.isEmpty) return null;
      return BioModel(en: text, ar: text);
    }
    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      return BioModel(
        en: (map['en'] ?? map['EN'] ?? map['english'])?.toString(),
        ar: (map['ar'] ?? map['AR'] ?? map['arabic'])?.toString(),
      );
    }
    return null;
  }

  Map<String, dynamic> toJson() => {"en": en, "ar": ar};
}

class RatingModel extends RatingEntity {
  const RatingModel({super.average, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(average: json['average'], count: json['count']);
  }

  Map<String, dynamic> toJson() => {"average": average, "count": count};
}

class LocationModel extends LocationEntity {
  const LocationModel({
    super.city,
    super.district,
    super.street,
    super.latitude,
    super.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'],

      district: json['district'],

      street: json['street'],

      latitude: json['latitude'],

      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
    "city": city,
    "district": district,
    "street": street,
    "latitude": latitude,
    "longitude": longitude,
  };
}

class LanguageModel extends LanguageEntity {
  const LanguageModel({super.id, super.code, super.name});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'],

      code: json['code'],

      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "code": code, "name": name};
}

class DoctorSpecialtyModel extends DoctorSpecialtyEntity {
  const DoctorSpecialtyModel({
    super.id,
    super.icon,
    super.isActive,
    super.sortOrder,
    super.name,
    super.slug,
    super.hasChildren,
    super.doctorsCount,
    super.createdAt,
    super.updatedAt,
  });

  factory DoctorSpecialtyModel.fromJson(Map<String, dynamic> json) {
    return DoctorSpecialtyModel(
      id: json['id'],

      icon: json['icon'],

      isActive: json['is_active'],

      sortOrder: json['sort_order'],

      name: json['name'],

      slug: json['slug'],

      hasChildren: json['has_children'],

      doctorsCount: json['doctors_count'],

      createdAt: json['created_at'],

      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "icon": icon,
    "is_active": isActive,
    "sort_order": sortOrder,
    "name": name,
    "slug": slug,
    "has_children": hasChildren,
    "doctors_count": doctorsCount,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    super.id,
    super.dayOfWeek,
    super.dayName,
    super.startTime,
    super.endTime,
    super.slotDuration,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],

      dayOfWeek: json['day_of_week'],

      dayName: json['day_name'],

      startTime: json['start_time'],

      endTime: json['end_time'],

      slotDuration: json['slot_duration'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "day_of_week": dayOfWeek,
    "day_name": dayName,
    "start_time": startTime,
    "end_time": endTime,
    "slot_duration": slotDuration,
  };
}

class MedicalCenterModel extends MedicalCenter {
  const MedicalCenterModel({
    super.id,
    super.name,
    super.description,
    super.address,
    super.countryCode,
    super.phone,
    super.email,
    super.logo,
    super.cover,
    super.isActive,
    super.latitude,
    super.longitude,
    super.createdAt,
    super.updatedAt,
  });

  factory MedicalCenterModel.fromJson(Map<String, dynamic> json) {
    return MedicalCenterModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      countryCode: json['country_code'],
      phone: json['phone'],
      email: json['email'],
      logo: json['logo'],
      cover: json['cover'],
      isActive: json['is_active'],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "address": address,
    "country_code": countryCode,
    "phone": phone,
    "email": email,
    "logo": logo,
    "cover": cover,
    "is_active": isActive,
    "latitude": latitude,
    "longitude": longitude,
  };
}
