import 'package:alhakim/features/doctors/data/datasources/doctors_remote_data_source.dart';
import 'package:alhakim/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:alhakim/features/doctors/domain/repositories/doctor_repository.dart';
import 'package:alhakim/features/doctors/domain/usecases/add_doctor_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/close_clinic_today_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/delete_doctor_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctor_appoinments_for_day_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctor_home_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctors_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_medical_center_doctors_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/reschedule_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/toggle_clinic_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/toggle_doctor_status_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/update_doctor_usecase.dart';
import 'package:alhakim/features/doctors/presentation/cubit/add_doctor_cubit/add_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/close_clinic_today_cubit/close_clinic_today_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/delete_doctor/delete_doctor_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_appoinments_for_day_cubit/get_doctor_appoinments_for_day_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctor_home_cubit/get_doctor_home_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_doctors_cubit/get_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/get_medical_center_doctors_cubit/get_medical_center_doctors_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/reschedule_cubit/reschedule_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggel_doctor_status/toggel_doctor_status_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/toggle_clinic_cubit/toggle_clinic_cubit.dart';
import 'package:alhakim/features/doctors/presentation/cubit/update_doctor_cubit/update_doctor_cubit.dart';
import 'package:alhakim/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initDoctorsFeatureInjection() async {
  /// cubit
  _sl.registerFactory(() => GetDoctorsCubit(usecase: _sl()));
  _sl.registerFactory(() => GetMedicalCenterDoctorsCubit(usecase: _sl()));
  _sl.registerFactory(() => AddDoctorCubit(usecase: _sl()));
  _sl.registerFactory(() => UpdateDoctorCubit(usecase: _sl()));
  _sl.registerFactory(() => GetDoctorHomeCubit(usecase: _sl()));
  _sl.registerFactory(() => CloseClinicTodayCubit(usecase: _sl()));
  _sl.registerFactory(() => DeleteDoctorCubit(usecase: _sl()));
  _sl.registerFactory(() => ToggelDoctorStatusCubit(usecase: _sl()));
  _sl.registerFactory(() => ToggleClinicCubit(usecase: _sl()));
  _sl.registerFactory(() => GetDoctorAppoinmentsForDayCubit(usecase: _sl()));
  _sl.registerFactory(() => RescheduleCubit(usecase: _sl()));

  /// usecase

  _sl.registerLazySingleton(
    () => GetDoctorAppoinmentsForDayUsecase(repository: _sl()),
  );
  _sl.registerLazySingleton(
    () => GetMedicalCenterDoctorsUsecase(repository: _sl()),
  );
  _sl.registerLazySingleton(() => ToggleClinicUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => ToggleDoctorStatusUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => AddDoctorUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => UpdateDoctorUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => GetDoctorHomeUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => CloseClinicTodayUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => DeleteDoctorUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => GetDoctorsUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => RescheduleUsecase(repository: _sl()));

  /// repo
  _sl.registerLazySingleton<DoctorRepository>(
    () => DoctorRepositoryImpl(remoteDataSource: _sl()),
  );

  /// datasource
  _sl.registerLazySingleton<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSourceImpl(),
  );
}
