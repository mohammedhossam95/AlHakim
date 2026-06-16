import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, BaseListResponse>> getAppointments();
  Future<Either<Failure, BaseOneResponse>> cancelAppointment({
    required String appointmentId,
  });
  Future<Either<Failure, BaseOneResponse>> getQueueStatus({
    required String appointmentId,
  });
}
