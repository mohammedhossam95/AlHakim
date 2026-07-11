import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctor_home_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_doctor_home_state.dart';

class GetDoctorHomeCubit extends Cubit<GetDoctorHomeState> {
  final GetDoctorHomeUsecase usecase;

  GetDoctorHomeCubit({required this.usecase}) : super(GetDoctorHomeInitial());

  bool _hasLoaded = false;

  Future<void> loadIfNeeded(int id) async {
    if (_hasLoaded) return;

    _hasLoaded = true;
    await getDoctorHome(id);
  }

  Future<void> getDoctorHome(int id) async {
    emit(GetDoctorHomeLoading());

    final result = await usecase(id);

    result.fold(
      (l) => emit(GetDoctorHomeError(message: l.message ?? '')),
      (r) => emit(GetDoctorHomeSuccess(response: r)),
    );
  }
}
