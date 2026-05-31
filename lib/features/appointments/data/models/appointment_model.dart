import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/appointments/domain/entities/appointment_entity.dart';

class AppointmentRespModel
    extends BaseListResponse {
  const AppointmentRespModel({
    super.status,
    super.message,
    super.data,
  });

  factory AppointmentRespModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppointmentRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map(
                (e) =>
                    AppointmentModel.fromJson(
                  e,
                ),
              )
              .toList()
          : [],
    );
  }
}

class AppointmentModel
    extends AppointmentEntity {
  const AppointmentModel({
    super.id,
    super.appointmentDate,
    super.status,
    super.doctor,
    super.createdAt,
  });

  factory AppointmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppointmentModel(
      id: json['id'],
      appointmentDate:
          json['appointment_date'],
      status: json['status'],
      doctor: json['doctor'] != null
          ? AppointmentDoctorModel
              .fromJson(
              json['doctor'],
            )
          : null,
      createdAt: json['created_at'],
    );
  }
}

class AppointmentDoctorModel
    extends AppointmentDoctorEntity {
  const AppointmentDoctorModel({
    super.id,
    super.name,
    super.price,
    super.rating,
    super.city,
    super.clinicPhone,
    super.profileImage,
    super.isActive,
    super.specialty,
  });

  factory AppointmentDoctorModel
      .fromJson(
    Map<String, dynamic> json,
  ) {
    return AppointmentDoctorModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      rating: json['rating'] != null
          ? AppointmentRatingModel
              .fromJson(
              json['rating'],
            )
          : null,
      city: json['city'],
      clinicPhone:
          json['clinic_phone'],
      profileImage:
          json['profile_image'],
      isActive: json['is_active'],
      specialty:
          json['specialty'] != null
              ? AppointmentSpecialtyModel
                  .fromJson(
                  json['specialty'],
                )
              : null,
    );
  }
}

class AppointmentRatingModel
    extends AppointmentRatingEntity {
  const AppointmentRatingModel({
    super.average,
    super.count,
  });

  factory AppointmentRatingModel
      .fromJson(
    Map<String, dynamic> json,
  ) {
    return AppointmentRatingModel(
      average: json['average'],
      count: json['count'],
    );
  }
}

class AppointmentSpecialtyModel
    extends AppointmentSpecialtyEntity {
  const AppointmentSpecialtyModel({
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

  factory AppointmentSpecialtyModel
      .fromJson(
    Map<String, dynamic> json,
  ) {
    return AppointmentSpecialtyModel(
      id: json['id'],
      icon: json['icon'],
      isActive: json['is_active'],
      sortOrder: json['sort_order'],
      name: json['name'],
      slug: json['slug'],
      hasChildren:
          json['has_children'],
      doctorsCount:
          json['doctors_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}