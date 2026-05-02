import 'package:alhakim/features/auth/domain/usecases/delete_user_account_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/get_all_cities_use_case.dart';
import 'package:alhakim/features/auth/domain/usecases/get_countries_use_case.dart';
import 'package:alhakim/features/auth/domain/usecases/get_setting_use_case.dart';
import 'package:alhakim/features/auth/domain/usecases/get_user_type_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/login_use_case.dart';
import 'package:alhakim/features/auth/domain/usecases/logout_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/register_use_case.dart';
import 'package:alhakim/features/auth/domain/usecases/save_user_type_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/send_code_use_case.dart';
import 'package:alhakim/features/auth/domain/usecases/verify_code_use_case.dart';
import 'package:alhakim/features/auth/presentation/cubit/delete_user_account/delete_user_account_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_all_cities_cubit/get_all_cities_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_countries_cubit/get_countries_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/get_setting/get_setting_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/send_code_cubit/send_code_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:alhakim/features/auth/presentation/cubit/verify_code_cubit/verify_code_cubit.dart';

import '/features/auth/presentation/cubit/accept_terms_cubit/accept_terms_cubit.dart';
import '../../injection_container.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/repositories/auth_repo_impl.dart';
import 'domain/repositories/auth_repo.dart';
import 'domain/usecases/get_session_usecase.dart';
import 'domain/usecases/save_session_usecase.dart';
import 'presentation/cubit/login/login_cubit.dart';

final _sl = ServiceLocator.instance;

Future<void> initAuthFeatureInjection() async {
  ///-> Cubits

  _sl.registerFactory<LoginCubit>(() => LoginCubit(loginUseCase: _sl()));
  _sl.registerFactory<VerifyCodeCubit>(
    () => VerifyCodeCubit(verifyCodeUseCase: _sl()),
  );
  _sl.registerFactory<SendCodeCubit>(
    () => SendCodeCubit(sendCodeUseCase: _sl()),
  );
  _sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(registerUseCase: _sl()),
  );
  _sl.registerFactory<GetAllCitiesCubit>(
    () => GetAllCitiesCubit(getAllCitiesUseCase: _sl()),
  );
  _sl.registerFactory<GetCountriesCubit>(
    () => GetCountriesCubit(getCountriesUseCase: _sl()),
  );

  _sl.registerLazySingleton<SessionCubit>(
    () => SessionCubit(
      getSessionStatus: _sl<GetSessionStatusUseCase>(),
      saveSessionStatus: _sl<SaveSessionStatusUseCase>(),
      getUserType: _sl<GetUserTypeUseCase>(),
      saveUserType: _sl<SaveUserTypeUseCase>(),
      logoutUseCase: _sl<LogoutUseCase>(),
    ),
  );
  _sl.registerFactory<AcceptTermsCubit>(() => AcceptTermsCubit());
  _sl.registerFactory<GetSettingCubit>(
    () => GetSettingCubit(getSettingUseCase: _sl()),
  );
  _sl.registerFactory<DeleteUserAccountCubit>(
    () => DeleteUserAccountCubit(_sl()),
  );

  ///-> UseCases

  _sl.registerLazySingleton<GetSessionStatusUseCase>(
    () => GetSessionStatusUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<SaveSessionStatusUseCase>(
    () => SaveSessionStatusUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<GetUserTypeUseCase>(
    () => GetUserTypeUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<SaveUserTypeUseCase>(
    () => SaveUserTypeUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(repository: _sl()),
  );

  _sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<VerifyCodeUseCase>(
    () => VerifyCodeUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<SendCodeUseCase>(
    () => SendCodeUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<GetAllCitiesUseCase>(
    () => GetAllCitiesUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<GetCountriesUseCase>(
    () => GetCountriesUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<GetSettingUseCase>(
    () => GetSettingUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<DeleteUserAccountUsecase>(
    () => DeleteUserAccountUsecase(repository: _sl()),
  );

  ///-> Repository
  _sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: _sl()),
  );

  ///-> DataSource
  _sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
}
