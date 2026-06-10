import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';

class DoctorsRespModel extends BaseListResponse {
  const DoctorsRespModel({super.status, super.message, super.data});

  factory DoctorsRespModel.fromJson(Map<String, dynamic> json) {
    return DoctorsRespModel(
      status: json['status'],

      message: json['message'],

      data: json['data'] != null
          ? (json['data'] as List).map((e) => DoctorModel.fromJson(e)).toList()
          : [],
    );
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
    super.clinicPhone,
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
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],

      name: json['name'] != null ? NameModel.fromJson(json['name']) : null,

      bio: json['bio'] != null ? BioModel.fromJson(json['bio']) : null,

      price: json['price'],
      priceHidden: json['price_hidden'],

      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,

      isActive: json['is_active'],

      isClinicOpen: json['is_clinic_open'],

      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,

      professionalRegistrationNumber: json['professional_registration_number'],

      academicDegree: json['academic_degree'],

      clinicPhone: json['clinic_phone'],

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

      minPatients: json['min_patients'].toString(),

      representativeCode: json['representative_code'],

      secretaryCountryCode: json['secretary_country_code'],
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

    "clinic_phone": clinicPhone,

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
  };
}

class NameModel extends NameEntity {
  const NameModel({super.en, super.ar});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(en: json['en'], ar: json['ar']);
  }

  Map<String, dynamic> toJson() => {"en": en, "ar": ar};
}

class BioModel extends BioEntity {
  const BioModel({super.en, super.ar});

  factory BioModel.fromJson(Map<String, dynamic> json) {
    return BioModel(en: json['en'], ar: json['ar']);
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
