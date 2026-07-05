import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/delegate/domain/usecases/delete_medical_center_usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/delete_medical_center_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_medical_center_state.dart';

class DeleteMedicalCenterCubit extends Cubit<DeleteMedicalCenterState> {
  final DeleteMedicalCenterUsecase usecase;

  DeleteMedicalCenterCubit({required this.usecase})
      : super(DeleteMedicalCenterInitial());

  Future<void> deleteMedicalCenter(String id) async {
    emit(DeleteMedicalCenterLoading());

    final result = await usecase(
      DeleteMedicalCenterParams(medicalCenterId: id),
    );

    result.fold(
      (l) => emit(DeleteMedicalCenterError(message: l.message ?? '')),
      (r) => emit(DeleteMedicalCenterSuccess(response: r)),
    );
  }
}
