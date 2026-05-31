import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/quick_booking_params.dart';
import 'package:dartz/dartz.dart';

abstract class QueueManagementRepository {
  Future<Either<Failure, BaseListResponse>> getQueueManagement({
    required String doctorId,
  });

  Future<Either<Failure, BaseOneResponse>> updateQueueStatus({
    required String doctorId,
    required int appointmentId,
    required String status,
  });
  Future<Either<Failure, BaseOneResponse>> quickBooking({
    required QuickBookingParams params,
  });
}
