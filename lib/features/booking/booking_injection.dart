import 'package:alhakim/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:alhakim/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:alhakim/features/booking/domain/repositories/booking_repository.dart';
import 'package:alhakim/features/booking/domain/usecases/add_family_member_usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/book_appointment_usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/get_family_members_usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/get_kinships_usecase.dart';
import 'package:alhakim/features/booking/presentation/cubit/add_family_member_cubit/add_family_member_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_family_members_cubit/get_family_members_cubit.dart';
import 'package:alhakim/features/booking/presentation/cubit/get_kinships_cubit/get_kinships_cubit.dart';
import 'package:alhakim/injection_container.dart';

final _sl = ServiceLocator.instance;

Future<void> initBookingFeatureInjection() async {
  /// cubit
  _sl.registerFactory(() => GetKinshipsCubit(usecase: _sl()));

  _sl.registerFactory(() => GetFamilyMembersCubit(usecase: _sl()));

  _sl.registerFactory(() => AddFamilyMemberCubit(usecase: _sl()));
  _sl.registerFactory(() => BookAppointmentCubit(usecase: _sl()));

  /// usecases

  _sl.registerLazySingleton(() => BookAppointmentUsecase(repository: _sl()));
  _sl.registerLazySingleton(() => GetFamilyMembersUsecase(repository: _sl()));

  _sl.registerLazySingleton(() => AddFamilyMemberUsecase(repository: _sl()));

  _sl.registerLazySingleton(() => GetKinshipsUsecase(repository: _sl()));

  /// repository
  _sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: _sl()),
  );

  /// datasource
  _sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(),
  );
}
