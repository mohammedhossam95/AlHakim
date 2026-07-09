import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/delegate/domain/usecases/get_medical_centers_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_medical_centers_state.dart';

class GetMedicalCentersCubit extends Cubit<GetMedicalCentersState> {
  final GetMedicalCentersUsecase usecase;

  GetMedicalCentersCubit({required this.usecase})
      : super(GetMedicalCentersInitial());

  bool _hasLoaded = false;

  Future<void> loadIfNeeded() async {
    if (_hasLoaded) return;

    _hasLoaded = true;
    await getMedicalCenters();
  }

  Future<void> getMedicalCenters() async {
    emit(GetMedicalCentersLoading());

    final result = await usecase(NoParams());

    result.fold(
      (l) => emit(GetMedicalCentersError(message: l.message ?? '')),
      (r) => emit(GetMedicalCentersSuccess(response: r)),
    );
  }
}
