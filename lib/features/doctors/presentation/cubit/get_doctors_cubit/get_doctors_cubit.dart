import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/doctors/domain/usecases/get_doctors_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_doctors_state.dart';

class GetDoctorsCubit extends Cubit<GetDoctorsState> {
  final GetDoctorsUsecase usecase;

  GetDoctorsCubit({required this.usecase})
      : super(GetDoctorsInitial());

  Future<void> getDoctors() async {
    emit(GetDoctorsLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetDoctorsError(message: l.message ?? '')),
      (r) => emit(GetDoctorsSuccess(response: r)),
    );
  }
}