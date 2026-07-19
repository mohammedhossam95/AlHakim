import 'package:alhakim/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:alhakim/features/notifications/data/repositories/notifications_repo_impl.dart';
import 'package:alhakim/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:alhakim/features/notifications/domain/usecases/get_notifications_count_usecase.dart';
import 'package:alhakim/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:alhakim/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:alhakim/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:alhakim/features/notifications/presentation/cubits/notifications_count_cubit/notifications_count_cubit.dart';
import 'package:alhakim/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import 'package:alhakim/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initNotificationsFeatureInjection() async {
  ///-> Cubits
  _sl.registerFactory<NotificationsCountCubit>(
    () => NotificationsCountCubit(_sl()),
  );
  _sl.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(
      getNotificationsUseCase: _sl(),
      markNotificationAsReadUseCase: _sl(),
      markAllNotificationsAsReadUseCase: _sl(),
    ),
  );

  ///-> UseCases
  _sl.registerLazySingleton<NotificationsCountUseCase>(
    () => NotificationsCountUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<MarkNotificationAsReadUseCase>(
    () => MarkNotificationAsReadUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<MarkAllNotificationsAsReadUseCase>(
    () => MarkAllNotificationsAsReadUseCase(repository: _sl()),
  );

  ///-> Repository
  _sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(remote: _sl()),
  );

  ///-> DataSource
  _sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(),
  );
}
