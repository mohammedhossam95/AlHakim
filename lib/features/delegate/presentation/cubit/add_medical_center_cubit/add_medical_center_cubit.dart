import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/delegate/domain/usecases/add_medical_center_usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/params/add_medical_center_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_medical_center_state.dart';

class AddMedicalCenterCubit extends Cubit<AddMedicalCenterState> {
  final AddMedicalCenterUsecase usecase;

  AddMedicalCenterCubit({required this.usecase})
      : super(AddMedicalCenterInitial());

  Future<void> addMedicalCenter(AddMedicalCenterParams params) async {
    emit(AddMedicalCenterLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(AddMedicalCenterError(message: l.message ?? '')),
      (r) => emit(AddMedicalCenterSuccess(response: r)),
    );
  }
}
