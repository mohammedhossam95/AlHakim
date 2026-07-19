import 'package:alhakim/core/api/dio_consumer.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/features/notifications/data/models/notification_model.dart';
import 'package:alhakim/features/notifications/domain/usecases/params/mark_notification_as_read_params.dart';
import 'package:alhakim/injection_container.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsRespModel> getRemoteNotifications();

  Future<BaseOneResponse> markNotificationAsRead(
    MarkNotificationAsReadParams params,
  );

  Future<BaseOneResponse> markAllNotificationsAsRead();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  @override
  Future<NotificationsRespModel> getRemoteNotifications() async {
    try {
      final dynamic response = await dioConsumer.get(
        ApiConstants.getNotifications,
      );

      if (response['status'] == true) {
        return NotificationsRespModel.fromJson(
          response as Map<String, dynamic>,
        );
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> markNotificationAsRead(
    MarkNotificationAsReadParams params,
  ) async {
    try {
      final encodedId = Uri.encodeComponent(params.notificationId);
      final dynamic response = await dioConsumer.post(
        '${ApiConstants.getNotifications}/$encodedId/read',
      );

      if (response['status'] == true) {
        return BaseOneResponse.fromJson(response as Map<String, dynamic>);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> markAllNotificationsAsRead() async {
    try {
      final dynamic response = await dioConsumer.post(
        ApiConstants.markAllNotificationsAsRead,
      );

      if (response['status'] == true) {
        return BaseOneResponse.fromJson(response as Map<String, dynamic>);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
