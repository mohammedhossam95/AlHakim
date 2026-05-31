import 'package:alhakim/features/delegate/data/datasources/representative_remote_data_source.dart';
import 'package:alhakim/features/delegate/data/repositories/representative_repository_impl.dart';
import 'package:alhakim/features/delegate/domain/repositories/representative_repository.dart';
import 'package:alhakim/features/delegate/domain/usecases/get_representative_stats_usecase.dart';
import 'package:alhakim/features/delegate/presentation/cubit/get_representative_stats_cubit/get_representative_stats_cubit.dart';
import 'package:alhakim/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initDelegateFeatureInjection() async {
  /// cubit
  _sl.registerFactory(() => GetRepresentativeStatsCubit(usecase: _sl()));

  /// usecase
  _sl.registerLazySingleton(
    () => GetRepresentativeStatsUsecase(repository: _sl()),
  );

  /// repository
  _sl.registerLazySingleton<RepresentativeStatsRepository>(
    () => RepresentativeStatsRepositoryImpl(remoteDataSource: _sl()),
  );

  /// datasource
  _sl.registerLazySingleton<RepresentativeStatsRemoteDataSource>(
    () => RepresentativeStatsRemoteDataSourceImpl(),
  );
}
