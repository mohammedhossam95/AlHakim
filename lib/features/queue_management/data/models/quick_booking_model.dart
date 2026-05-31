import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/queue_management/domain/entities/quick_booking_entity.dart';

class QuickBookingRespModel extends BaseOneResponse {
  const QuickBookingRespModel({super.status, super.message, super.data});

  factory QuickBookingRespModel.fromJson(Map<String, dynamic> json) {
    return QuickBookingRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? QuickBookingModel.fromJson(json['data'])
          : null,
    );
  }
}

class QuickBookingModel extends QuickBookingEntity {
  const QuickBookingModel({
    super.id,
    super.appointmentDate,
    super.status,
    super.queuePosition,
    super.isCurrent,
    super.createdAt,
  });

  factory QuickBookingModel.fromJson(Map<String, dynamic> json) {
    return QuickBookingModel(
      id: json['id'],
      appointmentDate: json['appointment_date'],
      status: json['status'],
      queuePosition: json['queue_position'],
      isCurrent: json['is_current'],
      createdAt: json['created_at'],
    );
  }
}
