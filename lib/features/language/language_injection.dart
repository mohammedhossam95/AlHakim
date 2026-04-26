import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';
import 'data/datasources/lang_local_data_source.dart';
import 'data/repositories/lang_repository_impl.dart';
import 'domain/repositories/lang_repository.dart';
import 'domain/usecases/change_lang.dart';
import 'domain/usecases/get_available_languages.dart';
import 'domain/usecases/get_saved_lang.dart';
import 'presentation/cubit/get_languages_cubit/get_languages_cubit.dart';
import 'presentation/cubit/locale_cubit/locale_cubit.dart';

Future<void> initLanguageFeatureInjection() async {
  /// Cubits
  ServiceLocator.instance.registerLazySingleton(
    () => LocaleCubit(
      changeLangUseCase: ServiceLocator.instance(),
      getSavedLangUseCase: ServiceLocator.instance(),
    ),
  );
  ServiceLocator.instance.registerLazySingleton(
    () => GetLanguagesCubit(getLanguagesList: ServiceLocator.instance()),
  );

  /// UseCases
  ServiceLocator.instance.registerLazySingleton(
    () => GetLanguagesList(repository: ServiceLocator.instance()),
  );
  ServiceLocator.instance.registerLazySingleton(
    () => GetSavedLangUseCase(repository: ServiceLocator.instance()),
  );
  ServiceLocator.instance.registerLazySingleton(
    () => ChangeLangUseCase(repository: ServiceLocator.instance()),
  );

  /// Repository
  ServiceLocator.instance.registerLazySingleton<LangRepository>(
    () => LangRepositoryImpl(langLocalDataSource: ServiceLocator.instance()),
  );

  /// DataSource
  ServiceLocator.instance.registerLazySingleton<LangLocalDataSource>(
    () => LangLocalDataSourceImpl(),
  );
}

/// BlocProviders
List<BlocProvider<StateStreamableSource<Object?>>> get languageBlocs =>
    <BlocProvider<StateStreamableSource<Object?>>>[
      BlocProvider<SessionCubit>(
        create: (_) => ServiceLocator.instance<SessionCubit>(),
      ),
      BlocProvider<LocaleCubit>(
        create: (BuildContext context) =>
            ServiceLocator.instance<LocaleCubit>(),
      ),
      BlocProvider<GetLanguagesCubit>(
        create: (BuildContext context) =>
            ServiceLocator.instance<GetLanguagesCubit>(),
      ),
    ];
