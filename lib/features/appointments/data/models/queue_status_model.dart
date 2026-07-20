import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/appointments/domain/entities/queue_status_entity.dart';

class QueueStatusRespModel extends BaseOneResponse {
  const QueueStatusRespModel({super.status, super.message, super.data});

  factory QueueStatusRespModel.fromJson(Map<String, dynamic> json) {
    return QueueStatusRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? QueueStatusModel.fromJson(json['data'])
          : null,
    );
  }
}

class QueueStatusModel extends QueueStatusEntity {
  const QueueStatusModel({
    super.appointmentId,
    super.status,
    super.isCurrent,
    super.clinicStarted,
    super.clinicOpen,
    super.isMissedTurn,
    super.yourQueueNumber,
    super.currentQueueNumber,
    super.patientsAhead,
    super.slotDuration,
    super.estimatedWaitMinutes,
    super.ads,
  });

  factory QueueStatusModel.fromJson(Map<String, dynamic> json) {
    return QueueStatusModel(
      appointmentId: json['appointment_id'],
      status: json['status']?.toString(),
      isCurrent: json['is_current'],
      clinicOpen: json['clinic_open'],
      clinicStarted: json['clinic_started'],
      isMissedTurn: json['is_missed_turn'],
      yourQueueNumber: json['your_queue_number']?.toString(),
      currentQueueNumber: json['current_queue_number']?.toString(),
      patientsAhead: json['patients_ahead'],
      slotDuration: json['slot_duration'],
      estimatedWaitMinutes: json['estimated_wait_minutes'],
      ads: json['ads'] != null
          ? (json['ads'] as List).map((e) => AdModel.fromJson(e)).toList()
          : null,
    );
  }
}

class AdModel extends Ad {
  const AdModel({super.id, super.photo, super.link});

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(id: json['id'], photo: json['photo'], link: json['link']);
  }

  Map<String, dynamic> toJson() => {"id": id, "photo": photo, "link": link};
}
