import 'package:alhakim/features/home/data/data_source/ai_consent_local_datasource.dart';
import 'package:alhakim/features/home/data/data_source/home_remote_datasource.dart';
import 'package:alhakim/features/home/data/repo_impl/ai_consent_repository_impl.dart';
import 'package:alhakim/features/home/data/repo_impl/home_repo_impl.dart';
import 'package:alhakim/features/home/domain/repo/ai_consent_repository.dart';
import 'package:alhakim/features/home/domain/repo/home_repo.dart';
import 'package:alhakim/features/home/domain/use_case/accept_ai_consent_usecase.dart';
import 'package:alhakim/features/home/domain/use_case/analyze_complaint_usecase.dart';
import 'package:alhakim/features/home/domain/use_case/get_ai_consent_usecase.dart';
import 'package:alhakim/features/home/domain/use_case/revoke_ai_consent_usecase.dart';
import 'package:alhakim/features/home/presentation/cubit/ai_consent_cubit/ai_consent_cubit.dart';
import 'package:alhakim/features/home/presentation/cubit/analyze_complaint_cubit/analyze_complaint_cubit.dart';

import '/injection_container.dart';
import 'domain/use_case/get_ads_usecase.dart';
import 'presentation/cubit/all_ads_cubit/all_ads_cubit.dart';

final _sl = ServiceLocator.instance;

Future<void> initHomeFeatureInjection() async {
  ///-> Cubits

  _sl.registerFactory<AllAdsCubit>(() => AllAdsCubit(usecase: _sl()));
  _sl.registerFactory<AnalyzeComplaintCubit>(
    () => AnalyzeComplaintCubit(useCase: _sl(), getAiConsentUseCase: _sl()),
  );
  _sl.registerFactory<AiConsentCubit>(
    () => AiConsentCubit(
      getAiConsentUseCase: _sl(),
      acceptAiConsentUseCase: _sl(),
      revokeAiConsentUseCase: _sl(),
    ),
  );

  ///-> UseCases

  _sl.registerLazySingleton<GetListAdsUsecase>(
    () => GetListAdsUsecase(repo: _sl()),
  );
  _sl.registerLazySingleton<AnalyzeComplaintUseCase>(
    () => AnalyzeComplaintUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<GetAiConsentUseCase>(
    () => GetAiConsentUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<AcceptAiConsentUseCase>(
    () => AcceptAiConsentUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<RevokeAiConsentUseCase>(
    () => RevokeAiConsentUseCase(repository: _sl()),
  );

  ///-> Repository
  _sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(remote: _sl()));
  _sl.registerLazySingleton<AiConsentRepository>(
    () => AiConsentRepositoryImpl(localDataSource: _sl()),
  );

  ///-> DataSource
  _sl.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(),
  );
  _sl.registerLazySingleton<AiConsentLocalDataSource>(
    () => AiConsentLocalDataSourceImpl(),
  );
}
