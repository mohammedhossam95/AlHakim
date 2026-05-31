import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/toggle_clinic_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'toggle_clinic_state.dart';

class ToggleClinicCubit extends Cubit<ToggleClinicState> {
  final ToggleClinicUsecase usecase;

  ToggleClinicCubit({required this.usecase}) : super(ToggleClinicInitial());

  Future<void> toggleClinic({required String doctorId}) async {
    emit(ToggleClinicLoading());

    final result = await usecase(doctorId);

    result.fold(
      (l) => emit(ToggleClinicError(message: l.message ?? '')),
      (r) => emit(ToggleClinicSuccess(response: r)),
    );
  }
}
