import 'package:alhakim/features/home/data/data_source/home_remote_datasource.dart';
import 'package:alhakim/features/home/data/repo_impl/home_repo_impl.dart';
import 'package:alhakim/features/home/domain/repo/home_repo.dart';
import 'package:alhakim/features/home/domain/use_case/get_home_bannars_usecase.dart';
import 'package:alhakim/features/home/presentation/cubit/home_bannares_cubit/home_banners_cubit.dart';

import '/injection_container.dart';
import 'domain/use_case/get_ads_usecase.dart';
import 'presentation/cubit/all_ads_cubit/all_ads_cubit.dart';

final _sl = ServiceLocator.instance;

Future<void> initHomeFeatureInjection() async {
  ///-> Cubits
  _sl.registerFactory<HomeBannaresCubit>(
    () => HomeBannaresCubit(usecase: _sl()),
  );
  _sl.registerFactory<AllAdsCubit>(() => AllAdsCubit(usecase: _sl()));

  ///-> UseCases
  _sl.registerLazySingleton<GetHomeBannarsUsecase>(
    () => GetHomeBannarsUsecase(repo: _sl()),
  );
  _sl.registerLazySingleton<GetListAdsUsecase>(
    () => GetListAdsUsecase(repo: _sl()),
  );

  ///-> Repository
  _sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(remote: _sl()));

  ///-> DataSource
  _sl.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(),
  );
}
