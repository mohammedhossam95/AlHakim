import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';

class AvailableBookingDate {
  final DateTime date;

  final ScheduleEntity schedule;

  const AvailableBookingDate({required this.date, required this.schedule});
}

class BookingDatesHelper {
  static List<AvailableBookingDate> generateAvailableDates(
    List<ScheduleEntity> schedules, {
    int limit = 7,
  }) {
    final List<AvailableBookingDate> result = [];

    final now = DateTime.now();

    int dayCounter = 0;

    while (result.length < limit) {
      final date = now.add(Duration(days: dayCounter));

      /// convert flutter weekday
      /// sunday => 0
      final apiWeekDay = date.weekday % 7;

      for (final schedule in schedules) {
        if (schedule.dayOfWeek == apiWeekDay) {
          result.add(AvailableBookingDate(date: date, schedule: schedule));

          break;
        }
      }

      dayCounter++;
    }

    return result;
  }
}
