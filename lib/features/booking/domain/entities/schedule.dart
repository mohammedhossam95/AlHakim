import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:intl/intl.dart';

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
    if (schedules.isEmpty) return [];

    final List<AvailableBookingDate> result = [];

    final now = DateTime.now();

    int dayCounter = 0;
    const maxDaySearch = 366;

    while (result.length < limit && dayCounter < maxDaySearch) {
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

  /// A date can't be booked when its schedule is full or the doctor has a
  /// schedule exception on that day.
  static bool isDateDisabled(
    AvailableBookingDate booking,
    List<ScheduleExceptionEntity>? exceptions,
  ) {
    final scheduleStatus = booking.schedule.scheduleStatus
        ?.toLowerCase()
        .trim();
    if (scheduleStatus == 'full') return true;

    final exceptionDates = exceptions ?? [];
    if (exceptionDates.isEmpty) return false;

    final bookingDateKey = DateFormat('yyyy-MM-dd').format(booking.date);
    return exceptionDates.any((exception) {
      final exceptionDate = exception.date?.trim();
      if (exceptionDate == null || exceptionDate.isEmpty) return false;
      return exceptionDate.startsWith(bookingDateKey);
    });
  }

  /// Returns -1 when every date is disabled.
  static int firstSelectableIndex(
    List<AvailableBookingDate> dates,
    List<ScheduleExceptionEntity>? exceptions,
  ) {
    return dates.indexWhere((booking) => !isDateDisabled(booking, exceptions));
  }
}
