import 'package:alhakim/features/delegate/data/datasources/medical_center_remote_data_source.dart';
import 'package:alhakim/features/delegate/data/datasources/representative_remote_data_source.dart';
import 'package:alhakim/features/delegate/data/repositories/medical_center_repository_impl.dart';
import 'package:alhakim/features/delegate/data/repositories/representative_repository_impl.dart';
import 'package:alhakim/features/delegate/domain/repositories/medical_center_repository.dart';
import 'package:alhakim/features/delegate/domain/repositories/representative_repository.dart';
import 'package:alhakim/features/delegate/domain/usecases/add_medical_center_usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/delete_medical_center_usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/get_medical_centers_usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/get_representative_stats_usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/toggle_medical_center_status_usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/update_medical_center_usecase.dart';
import 'package:alhakim/features/delegate/presentation/cubit/add_medical_center_cubit/add_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/delete_medical_center_cubit/delete_medical_center_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_medical_centers_cubit/get_medical_centers_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_representative_stats_cubit/get_representative_stats_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/toggle_medical_center_status_cubit/toggle_medical_center_status_cubit.dart';
import 'package:alhakim/features/delegate/presentation/cubit/update_medical_center_cubit/update_medical_center_cubit.dart';
import 'package:alhakim/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initDelegateFeatureInjection() async {
  /// cubit
  _sl.registerFactory(() => GetRepresentativeStatsCubit(usecase: _sl()));
  _sl.registerFactory(() => GetMedicalCentersCubit(usecase: _sl()));
  _sl.registerFactory(() => DeleteMedicalCenterCubit(usecase: _sl()));
  _sl.registerFactory(() => ToggleMedicalCenterStatusCubit(usecase: _sl()));
  _sl.registerFactory(() => AddMedicalCenterCubit(usecase: _sl()));
  _sl.registerFactory(() => UpdateMedicalCenterCubit(usecase: _sl()));

  /// usecase
  _sl.registerLazySingleton(
    () => GetRepresentativeStatsUsecase(repository: _sl()),
  );
  _sl.registerLazySingleton(
    () => GetMedicalCentersUsecase(repository: _sl()),
  );
  _sl.registerLazySingleton(
    () => DeleteMedicalCenterUsecase(repository: _sl()),
  );
  _sl.registerLazySingleton(
    () => ToggleMedicalCenterStatusUsecase(repository: _sl()),
  );
  _sl.registerLazySingleton(
    () => AddMedicalCenterUsecase(repository: _sl()),
  );
  _sl.registerLazySingleton(
    () => UpdateMedicalCenterUsecase(repository: _sl()),
  );

  /// repository
  _sl.registerLazySingleton<RepresentativeStatsRepository>(
    () => RepresentativeStatsRepositoryImpl(remoteDataSource: _sl()),
  );
  _sl.registerLazySingleton<MedicalCenterRepository>(
    () => MedicalCenterRepositoryImpl(remoteDataSource: _sl()),
  );

  /// datasource
  _sl.registerLazySingleton<RepresentativeStatsRemoteDataSource>(
    () => RepresentativeStatsRemoteDataSourceImpl(),
  );
  _sl.registerLazySingleton<MedicalCenterRemoteDataSource>(
    () => MedicalCenterRemoteDataSourceImpl(),
  );
}
