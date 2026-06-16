import 'package:alhakim/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:alhakim/features/appointments/data/repositories/appointment_repository_impl.dart';
import 'package:alhakim/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:alhakim/features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import 'package:alhakim/features/appointments/domain/usecases/get_appointments_usecase.dart';
import 'package:alhakim/features/appointments/domain/usecases/get_queue_status_usecase.dart';
import 'package:alhakim/features/appointments/presentation/cubt/cancel_appointment_cubit/cancel_appointment_cubit.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_appointments/get_appointments_cubit.dart';
import 'package:alhakim/features/appointments/presentation/cubt/get_queue_status/get_queue_status_cubit.dart';

import '/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initAppointmentsInjection() async {
  /// cubit
  _sl.registerFactory(() => GetAppointmentsCubit(usecase: _sl()));
  _sl.registerFactory(() => CancelAppointmentCubit(usecase: _sl()));
  _sl.registerFactory(() => GetQueueStatusCubit(usecase: _sl()));

  /// usecase

  _sl.registerLazySingleton(() => CancelAppointmentUsecase(repository: _sl()));

  _sl.registerLazySingleton(() => GetAppointmentsUsecase(repository: _sl()));

  _sl.registerLazySingleton(() => GetQueueStatusUsecase(repository: _sl()));

  /// repository
  _sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(remoteDataSource: _sl()),
  );

  /// datasource
  _sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(),
  );
}
