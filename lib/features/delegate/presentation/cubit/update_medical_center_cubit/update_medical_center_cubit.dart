import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/add_medical_center_params.dart';
import 'package:alhakim/features/delegate/domain/usecases/update_medical_center_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_medical_center_state.dart';

class UpdateMedicalCenterCubit extends Cubit<UpdateMedicalCenterState> {
  final UpdateMedicalCenterUsecase usecase;

  UpdateMedicalCenterCubit({required this.usecase})
      : super(UpdateMedicalCenterInitial());

  Future<void> updateMedicalCenter({
    required AddMedicalCenterParams params,
  }) async {
    emit(UpdateMedicalCenterLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(UpdateMedicalCenterError(message: l.message ?? '')),
      (r) => emit(UpdateMedicalCenterSuccess(response: r)),
    );
  }
}
