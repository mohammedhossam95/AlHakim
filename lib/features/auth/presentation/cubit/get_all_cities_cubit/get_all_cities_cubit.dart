import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/domain/usecases/get_all_cities_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';

part 'get_all_cities_state.dart';

class GetAllCitiesCubit extends Cubit<GetAllCitiesState> {
  final GetAllCitiesUseCase getAllCitiesUseCase;

  GetAllCitiesCubit({required this.getAllCitiesUseCase})
    : super(GetAllCitiesInitial());

  Future<void> getAllCities(AuthParams params) async {
    emit(GetAllCitiesIsLoading());
    try {
      final Either<Failure, BaseListResponse> eitherResult =
          await getAllCitiesUseCase(params);
      eitherResult.fold(
        (Failure failure) {
          emit(GetAllCitiesError(failure.message ?? ''));
        },
        (BaseListResponse response) {
          emit(GetAllCitiesLoaded(response: response));
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
