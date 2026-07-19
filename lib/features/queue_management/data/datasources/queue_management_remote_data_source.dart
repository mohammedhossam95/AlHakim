import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/core/params/quick_booking_params.dart';
import 'package:alhakim/features/queue_management/data/models/queue_management_model.dart';
import 'package:alhakim/features/queue_management/data/models/quick_booking_model.dart';
import 'package:alhakim/injection_container.dart';
import 'package:dio/dio.dart';

abstract class QueueManagementRemoteDataSource {
  Future<QueueManagementRespModel> getQueueManagement({
    required String doctorId,
  });
  Future<BaseOneResponse> updateQueueStatus({
    required String doctorId,
    required int appointmentId,
    required String status,
  });
  Future<BaseOneResponse> notifyExamination({required String appointmentId});
  Future<QuickBookingRespModel> quickBooking({
    required QuickBookingParams params,
  });
}

class QueueManagementRemoteDataSourceImpl
    implements QueueManagementRemoteDataSource {
  @override
  Future<QueueManagementRespModel> getQueueManagement({
    required String doctorId,
  }) async {
    try {
      final response = await dioConsumer.get(
        '/doctors/$doctorId/queue-management',
      );

      if (response['status'] == true) {
        return QueueManagementRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuickBookingRespModel> quickBooking({
    required QuickBookingParams params,
  }) async {
    try {
      final response = await dioConsumer.post(
        '/appointments/new-patient',

        formData: FormData.fromMap(params.toJson()),
      );

      if (response['status'] == true) {
        return QuickBookingRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> updateQueueStatus({
    required String doctorId,
    required int appointmentId,
    required String status,
  }) async {
    try {
      final response = await dioConsumer.post(
        '/doctors/$doctorId/queue-management/$appointmentId/status',

        formData: FormData.fromMap({"_method": "PATCH", "status": status}),
      );

      if (response['status'] == true) {
        return BaseOneResponse(
          status: response['status'],
          message: response['message'],
          data: response['data'],
        );
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> notifyExamination({
    required String appointmentId,
  }) async {
    try {
      final response = await dioConsumer.post(
        '/appointments/$appointmentId/notify-examination',
      );

      if (response['status'] == true) {
        return BaseOneResponse(
          status: response['status'],
          message: response['message'],
          data: response['data'],
        );
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }
}
