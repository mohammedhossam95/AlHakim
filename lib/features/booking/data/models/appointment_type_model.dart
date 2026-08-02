import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/booking/domain/entities/appointment_type_entity.dart';

class AppointmentTypeRespModel extends BaseListResponse {
  const AppointmentTypeRespModel({super.status, super.message, super.data});

  factory AppointmentTypeRespModel.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null
          ? <AppointmentTypeModel>[]
          : List<AppointmentTypeModel>.from(
              (json['data'] as List).map(
                (x) => AppointmentTypeModel.fromJson(
                  Map<String, dynamic>.from(x as Map),
                ),
              ),
            ),
    );
  }
}

class AppointmentTypeModel extends AppointmentTypeEntity {
  const AppointmentTypeModel({
    required super.id,
    required super.name,
  });

  factory AppointmentTypeModel.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}
