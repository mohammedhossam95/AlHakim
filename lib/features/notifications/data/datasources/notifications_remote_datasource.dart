import '../../../../core/error/exceptions.dart';
import '../../../../injection_container.dart';
import '../models/get_notifications_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<GetNotificationsModel> getRemoteNotificationsCount();
  Future<GetNotificationsModel> getRemoteNotifications();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  @override
  Future<GetNotificationsModel> getRemoteNotificationsCount() async {
    try {
      final dynamic response = await dioConsumer.get('/notifications');

      if (response['success'] == true || response['success'] == 'true') {
        return GetNotificationsModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<GetNotificationsModel> getRemoteNotifications() async {
    //todo
    try {
      final dynamic response = await dioConsumer.get('/notifications');

      if (response['success'] == true || response['success'] == 'true') {
        return GetNotificationsModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
