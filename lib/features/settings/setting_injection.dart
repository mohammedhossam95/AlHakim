import 'package:alhakim/features/settings/domain/use_case/get_app_setting_usecase.dart';
import 'package:alhakim/features/settings/domain/use_case/get_common_questions_use_case.dart';
import 'package:alhakim/features/settings/domain/use_case/get_static_page_content_usecase.dart';
import 'package:alhakim/features/settings/domain/use_case/get_user_profile_use_case.dart';
import 'package:alhakim/features/settings/domain/use_case/update_user_profile_use_case.dart';
import 'package:alhakim/features/settings/presentaion/cubit/app_setting_cubit/app_setting_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/common_question_cubit/common_questions_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/get_user_profile_cubit/get_user_profile_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/static_page_content_cubit/static_page_content_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/update_user_profile_cubit/update_user_profile_cubit.dart';
import 'package:alhakim/features/settings/presentaion/cubit/user_cached_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/features/settings/data/data_source/setting_remote_data_source.dart';
import '/features/settings/domain/repo/setting_repo.dart';
import '/features/settings/domain/use_case/contact_us_use_case.dart';
import '/features/settings/domain/use_case/get_support_phone_use_case.dart';
import '/features/settings/domain/use_case/setting_use_case.dart';
import '/features/settings/presentaion/cubit/change_password_cubit/change_password_cubit.dart';
import '/features/settings/presentaion/cubit/contact_us_cubit/contact_us_cubit.dart';
import '/features/settings/presentaion/cubit/get_support_phone_cubit/get_support_phone_cubit.dart';
import '/injection_container.dart';
import 'data/repo_impl/remote_repo_impl.dart';

final _sl = ServiceLocator.instance;

Future<void> initsettingFeatureInjection() async {
  ///-> Cubits
  _sl.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit(_sl()));
  _sl.registerFactory<ContactUsCubit>(() => ContactUsCubit(_sl()));
  _sl.registerFactory<CommonQuestionsCubit>(() => CommonQuestionsCubit(_sl()));
  _sl.registerFactory<SupportPhoneCubit>(() => SupportPhoneCubit(_sl()));
  _sl.registerFactory<GetUserProfileCubit>(
    () => GetUserProfileCubit(getUserProfileUseCase: _sl()),
  );
  _sl.registerFactory<UpdateUserProfileCubit>(
    () => UpdateUserProfileCubit(udateUserProfileUseCase: _sl()),
  );
  _sl.registerFactory<StaticPageContentCubit>(
    () => StaticPageContentCubit(_sl()),
  );
  _sl.registerFactory<UserCubit>(() => UserCubit());
  _sl.registerFactory<AppSettingCubit>(() => AppSettingCubit(_sl()));

  ///-> UseCases
  _sl.registerLazySingleton<SettingUseCase>(() => SettingUseCase(_sl()));
  _sl.registerLazySingleton<ContactUsUseCase>(() => ContactUsUseCase(_sl()));
  _sl.registerLazySingleton<GetCommonQuestionsUseCase>(
    () => GetCommonQuestionsUseCase(settingRepo: _sl()),
  );
  _sl.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<UpdateUserProfileUseCase>(
    () => UpdateUserProfileUseCase(repository: _sl()),
  );
  _sl.registerLazySingleton<GetSupportPhoneUseCase>(
    () => GetSupportPhoneUseCase(_sl()),
  );
  _sl.registerLazySingleton<GetStaticPageContentUsecase>(
    () => GetStaticPageContentUsecase(_sl()),
  );
  _sl.registerLazySingleton<GetAppSettingUsecase>(
    () => GetAppSettingUsecase(repo: _sl()),
  );
  // Repository
  _sl.registerLazySingleton<SettingRepo>(
    () => SettingRemoteRepoImpl(settingRemoteDataSource: _sl()),
  );

  ///-> DataSource
  _sl.registerLazySingleton<SettingRemoteDataSource>(
    () => SettingRemoteDataSourceImpl(),
  );
}

///-> BlocProvider
List<BlocProvider> get settingBlocs => <BlocProvider>[
  //----------------new----------
  BlocProvider<ChangePasswordCubit>(
    create: (BuildContext context) => _sl<ChangePasswordCubit>(),
  ),

  BlocProvider<ContactUsCubit>(
    create: (BuildContext context) => _sl<ContactUsCubit>(),
  ),
  BlocProvider<CommonQuestionsCubit>(
    create: (BuildContext context) => _sl<CommonQuestionsCubit>(),
  ),
  BlocProvider<GetUserProfileCubit>(
    create: (BuildContext context) => _sl<GetUserProfileCubit>(),
  ),
  BlocProvider<UpdateUserProfileCubit>(
    create: (BuildContext context) => _sl<UpdateUserProfileCubit>(),
  ),
  BlocProvider<StaticPageContentCubit>(
    create: (BuildContext context) => _sl<StaticPageContentCubit>(),
  ),
  BlocProvider<UserCubit>(create: (BuildContext context) => _sl<UserCubit>()),
  BlocProvider<AppSettingCubit>(
    create: (BuildContext context) => _sl<AppSettingCubit>(),
  ),
];
