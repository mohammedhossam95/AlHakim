import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/close_clinic_usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/params/close_clinic_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'close_clinic_state.dart';

class CloseClinicCubit extends Cubit<CloseClinicState> {
  final CloseClinicUsecase usecase;

  CloseClinicCubit({required this.usecase}) : super(CloseClinicInitial());

  Future<void> closeClinic({required CloseClinicParams params}) async {
    emit(CloseClinicLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(CloseClinicError(message: l.message ?? '')),
      (r) => emit(CloseClinicSuccess(response: r)),
    );
  }
}
