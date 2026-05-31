import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/doctors/domain/usecases/delete_doctor_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'delete_doctor_state.dart';

class DeleteDoctorCubit
    extends Cubit<DeleteDoctorState> {
  final DeleteDoctorUsecase usecase;

  DeleteDoctorCubit({
    required this.usecase,
  }) : super(DeleteDoctorInitial());

  Future<void> deleteDoctor(
    String id,
  ) async {
    emit(DeleteDoctorLoading());

    final result = await usecase(id);

    result.fold(
      (l) => emit(
        DeleteDoctorError(
          message: l.message ?? '',
        ),
      ),
      (r) => emit(
        DeleteDoctorSuccess(
          response: r,
        ),
      ),
    );
  }
}