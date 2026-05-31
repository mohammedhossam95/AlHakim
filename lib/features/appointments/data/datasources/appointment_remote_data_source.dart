import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/features/appointments/data/models/appointment_model.dart';
import 'package:alhakim/injection_container.dart';
import 'package:dio/dio.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentRespModel> getAppointments();
  Future<BaseOneResponse> cancelAppointment({required String appointmentId});
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  @override
  Future<AppointmentRespModel> getAppointments() async {
    try {
      final response = await dioConsumer.get('/appointments');

      if (response['status'] == true) {
        return AppointmentRespModel.fromJson(response);
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> cancelAppointment({
    required String appointmentId,
  }) async {
    try {
      final response = await dioConsumer.post(
        '/appointments/$appointmentId/cancel',

        formData: FormData.fromMap({"_method": "PATCH"}),
      );

      if (response['status'] == true) {
        return BaseOneResponse(
          status: response['status'],
          message: response['message'],
        );
      }

      throw ServerException(message: response['message'] ?? '');
    } catch (e) {
      rethrow;
    }
  }
}
