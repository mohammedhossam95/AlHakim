import '/features/notifications/data/datasources/notifications_remote_datasource.dart';
import '/features/notifications/data/repositories/notifications_repo_impl.dart';
import '/features/notifications/domain/repositories/notifications_repo.dart';
import '/features/notifications/domain/usecases/get_notifications_count_usecase.dart';
import '/features/notifications/domain/usecases/get_notifications_usecase.dart';
import '/features/notifications/presentation/cubits/notifications_count_cubit/notifications_count_cubit.dart';
import '/features/notifications/presentation/cubits/notifications_cubit/notifications_cubit.dart';
import '/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initNotificationsFeatureInjection() async {
  ///-> Cubits
  _sl.registerFactory<NotificationsCountCubit>(
      () => NotificationsCountCubit(_sl()));
  _sl.registerFactory<NotificationsCubit>(() => NotificationsCubit(_sl()));
  // _sl.registerLazySingleton<ReadNotificationCubit>(() => ReadNotificationCubit(_sl()));

  ///-> UseCases

  _sl.registerLazySingleton<NotificationsCountUseCase>(
      () => NotificationsCountUseCase(repository: _sl()));
  _sl.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(repository: _sl()));
  // _sl.registerLazySingleton<ReadNotificationUseCase>(() => ReadNotificationUseCase(repository: _sl()));

  ///-> Repository
  _sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(remote: _sl()));

  ///-> DataSource
  _sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl());
}
