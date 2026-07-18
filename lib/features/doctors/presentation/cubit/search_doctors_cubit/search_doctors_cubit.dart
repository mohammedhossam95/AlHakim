import 'dart:async';

import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/domain/usecases/params/search_doctors_params.dart';
import 'package:alhakim/features/doctors/domain/usecases/search_doctors_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_doctors_state.dart';

class SearchDoctorsCubit extends Cubit<SearchDoctorsState> {
  final SearchDoctorsUsecase usecase;

  SearchDoctorsCubit({required this.usecase}) : super(SearchDoctorsInitial());

  Timer? _debounce;
  int _requestId = 0;
  String _latestQuery = '';

  void search(String query) {
    _debounce?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _latestQuery = '';
      _requestId++;
      emit(SearchDoctorsInitial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(trimmed);
    });
  }

  Future<void> _performSearch(String query) async {
    final requestId = ++_requestId;
    _latestQuery = query;

    final previousDoctors = _previousDoctorsFromState(state);
    emit(SearchDoctorsLoading(previousDoctors: previousDoctors));

    final result = await usecase(
      SearchDoctorsParams(search: query),
    );

    if (isClosed || requestId != _requestId || query != _latestQuery) {
      return;
    }

    result.fold(
      (l) => emit(SearchDoctorsError(message: l.message ?? '')),
      (r) {
        final doctors = (r.data as List<DoctorEntity>?) ?? [];
        if (doctors.isEmpty) {
          emit(const SearchDoctorsEmpty());
        } else {
          emit(SearchDoctorsLoaded(doctors: doctors));
        }
      },
    );
  }

  List<DoctorEntity> _previousDoctorsFromState(SearchDoctorsState current) {
    if (current is SearchDoctorsLoaded) {
      return current.doctors;
    }
    if (current is SearchDoctorsLoading) {
      return current.previousDoctors;
    }
    return const [];
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
