import 'dart:async';

import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/specialities/domain/usecases/get_specialty_doctors_usecase.dart';
import 'package:alhakim/features/specialities/domain/usecases/params/get_specialty_doctors_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_specialty_doctors_state.dart';

class GetSpecialtyDoctorsCubit extends Cubit<GetSpecialtyDoctorsState> {
  final GetSpecialtyDoctorsUsecase usecase;

  GetSpecialtyDoctorsCubit({required this.usecase})
    : super(GetSpecialtyDoctorsInitial());

  Timer? _debounce;
  int _requestId = 0;
  int? _specialtyId;
  String? _latestSearch;

  /// Immediate fetch (initial load / retry). Always preserves [specialtyId].
  Future<void> getSpecialtyDoctors(GetSpecialtyDoctorsParams params) async {
    _debounce?.cancel();
    _specialtyId = params.specialtyId;
    await _fetch(params);
  }

  /// Debounced search within the current specialty. Clears search → full list.
  void search(String query) {
    final specialtyId = _specialtyId;
    if (specialtyId == null) return;

    _debounce?.cancel();

    final trimmed = query.trim();
    final search = trimmed.isEmpty ? null : trimmed;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetch(
        GetSpecialtyDoctorsParams(
          specialtyId: specialtyId,
          search: search,
        ),
      );
    });
  }

  Future<void> _fetch(GetSpecialtyDoctorsParams params) async {
    final requestId = ++_requestId;
    _specialtyId = params.specialtyId;
    _latestSearch = params.search;

    final previousResponse = _previousResponseFromState(state);
    emit(GetSpecialtyDoctorsLoading(previousResponse: previousResponse));

    final result = await usecase(params);

    if (isClosed ||
        requestId != _requestId ||
        params.specialtyId != _specialtyId ||
        params.search != _latestSearch) {
      return;
    }

    result.fold(
      (l) => emit(GetSpecialtyDoctorsError(message: l.message ?? '')),
      (r) => emit(GetSpecialtyDoctorsSuccess(response: r)),
    );
  }

  BaseListResponse? _previousResponseFromState(GetSpecialtyDoctorsState current) {
    if (current is GetSpecialtyDoctorsSuccess) {
      return current.response;
    }
    if (current is GetSpecialtyDoctorsLoading) {
      return current.previousResponse;
    }
    return null;
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
