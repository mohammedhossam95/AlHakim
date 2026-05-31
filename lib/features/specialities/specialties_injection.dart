import 'package:alhakim/features/specialities/data/datasources/specialty_remote_data_source.dart';
import 'package:alhakim/features/specialities/data/repositories/specialty_repository_impl.dart';
import 'package:alhakim/features/specialities/domain/repositories/specialty_repository.dart';
import 'package:alhakim/features/specialities/domain/usecases/get_specialties_usecase.dart';
import 'package:alhakim/features/specialities/domain/usecases/get_specialty_doctors_usecase.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialties_cubit/get_specialties_cubit.dart';
import 'package:alhakim/features/specialities/presentation/cubit/get_specialty_doctors_cubit/get_specialty_doctors_cubit.dart';

import '/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initSpecialtiesInjection() async {
  /// cubit
  _sl.registerFactory(() => GetSpecialtiesCubit(usecase: _sl()));

  /// cubit
  _sl.registerFactory(() => GetSpecialtyDoctorsCubit(usecase: _sl()));

  /// usecase
  _sl.registerLazySingleton(
    () => GetSpecialtyDoctorsUsecase(repository: _sl()),
  );

  _sl.registerLazySingleton(() => GetSpecialtiesUsecase(repository: _sl()));

  /// repo
  _sl.registerLazySingleton<SpecialtyRepository>(
    () => SpecialtyRepositoryImpl(remoteDataSource: _sl()),
  );

  /// datasource
  _sl.registerLazySingleton<SpecialtyRemoteDataSource>(
    () => SpecialtyRemoteDataSourceImpl(),
  );
}
