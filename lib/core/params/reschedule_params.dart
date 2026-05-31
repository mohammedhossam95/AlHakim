import 'package:equatable/equatable.dart';

class RescheduleParams extends Equatable {
  final String? doctorId;
  final String? date;
  final int? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final int? slotDuration;

  const RescheduleParams({
    this.doctorId,
    this.date,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.slotDuration,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (date != null) {
      data['date'] = date;
    }

    if (dayOfWeek != null) {
      data['day_of_week'] = dayOfWeek;
    }

    if (startTime != null) {
      data['start_time'] = startTime;
    }

    if (endTime != null) {
      data['end_time'] = endTime;
    }

    if (slotDuration != null) {
      data['slot_duration'] = slotDuration;
    }

    return data;
  }

  @override
  List<Object?> get props => [
    doctorId,
    date,
    dayOfWeek,
    startTime,
    endTime,
    slotDuration,
  ];
}
