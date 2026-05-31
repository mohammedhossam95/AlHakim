import 'package:alhakim/core/base_classes/base_one_response.dart';

class RescheduleRespModel extends BaseOneResponse {
  const RescheduleRespModel({super.status, super.message, super.data});

  factory RescheduleRespModel.fromJson(Map<String, dynamic> json) {
    return RescheduleRespModel(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}

// class RescheduleModel extends RescheduleEntity {
//   const RescheduleModel({
//     super.id,
//     super.dayName,
//     super.dayOfWeek,
//     super.startTime,
//     super.endTime,
//     super.slotDuration,
//   });

//   factory RescheduleModel.fromJson(Map<String, dynamic> json) {
//     return RescheduleModel(
//       id: json['id'],
//       dayName: json['day_name'],
//       dayOfWeek: json['day_of_week'],
//       startTime: json['start_time'],
//       endTime: json['end_time'],
//       slotDuration: json['slot_duration'],
//     );
//   }
// }
