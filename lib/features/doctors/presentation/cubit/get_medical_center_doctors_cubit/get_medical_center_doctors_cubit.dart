import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_medical_center_doctors_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_medical_center_doctors_state.dart';

class GetMedicalCenterDoctorsCubit extends Cubit<GetMedicalCenterDoctorsState> {
  final GetMedicalCenterDoctorsUsecase usecase;

  GetMedicalCenterDoctorsCubit({required this.usecase})
    : super(GetMedicalCenterDoctorsInitial());

  bool _hasLoaded = false;

  Future<void> loadIfNeeded(int id) async {
    if (_hasLoaded) return;

    _hasLoaded = true;
    await getMedicalCenterDoctors(id);
  }

  Future<void> getMedicalCenterDoctors(int id) async {
    emit(GetMedicalCenterDoctorsLoading());

    final result = await usecase(id);

    result.fold(
      (l) => emit(GetMedicalCenterDoctorsError(message: l.message ?? '')),
      (r) => emit(GetMedicalCenterDoctorsSuccess(response: r)),
    );
  }
}
