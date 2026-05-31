import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/add_doctor_params.dart';
import 'package:alhakim/features/doctors/domain/usecases/add_doctor_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_doctor_state.dart';

class AddDoctorCubit
    extends Cubit<AddDoctorState> {
  final AddDoctorUsecase usecase;

  AddDoctorCubit({
    required this.usecase,
  }) : super(AddDoctorInitial());

  Future<void> addDoctor(
    AddDoctorParams params,
  ) async {
    emit(AddDoctorLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(
        AddDoctorError(
          message: l.message ?? '',
        ),
      ),

      (r) => emit(
        AddDoctorSuccess(response: r),
      ),
    );
  }
}