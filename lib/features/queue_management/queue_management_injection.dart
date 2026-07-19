import 'package:alhakim/features/queue_management/data/datasources/queue_management_remote_data_source.dart';
import 'package:alhakim/features/queue_management/data/repositories/queue_management_repository_impl.dart';
import 'package:alhakim/features/queue_management/domain/repositories/queue_management_repository.dart';
import 'package:alhakim/features/queue_management/domain/usecases/get_queue_management_usecase.dart';
import 'package:alhakim/features/queue_management/domain/usecases/notify_examination_usecase.dart';
import 'package:alhakim/features/queue_management/domain/usecases/quick_booking_usecase.dart';
import 'package:alhakim/features/queue_management/domain/usecases/update_queue_status_usecase.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/get_queue_management_cubit/get_queue_management_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/notify_examination_cubit/notify_examination_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/quick_booking_cubit/quick_booking_cubit.dart';
import 'package:alhakim/features/queue_management/presentation/cubit/update_queue_status_cubit/update_queue_status_cubit.dart';
import 'package:alhakim/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initQueueManagementInjection() async {
  _sl.registerFactory(() => GetQueueManagementCubit(usecase: _sl()));
  _sl.registerFactory(() => UpdateQueueStatusCubit(usecase: _sl()));
  _sl.registerFactory(() => NotifyExaminationCubit(usecase: _sl()));
  _sl.registerFactory(() => QuickBookingCubit(usecase: _sl()));

  _sl.registerLazySingleton(() => QuickBookingUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => UpdateQueueStatusUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => NotifyExaminationUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => GetQueueManagementUsecase(repository: _sl()));

  _sl.registerLazySingleton<QueueManagementRepository>(
    () => QueueManagementRepositoryImpl(remoteDataSource: _sl()),
  );

  _sl.registerLazySingleton<QueueManagementRemoteDataSource>(
    () => QueueManagementRemoteDataSourceImpl(),
  );
}
