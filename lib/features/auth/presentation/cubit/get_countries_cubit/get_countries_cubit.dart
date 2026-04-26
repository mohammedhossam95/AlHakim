import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/get_countries_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';

part 'get_countries_state.dart';

class GetCountriesCubit extends Cubit<GetCountriesState> {
  final GetCountriesUseCase getCountriesUseCase;

  GetCountriesCubit({required this.getCountriesUseCase})
    : super(GetCountriesInitial());

  Future<void> getCountries() async {
    emit(GetCountriesIsLoading());
    try {
      final Either<Failure, BaseListResponse> eitherResult =
          await getCountriesUseCase(NoParams());
      eitherResult.fold(
        (Failure failure) {
          emit(GetCountriesError(failure.message ?? ''));
        },
        (BaseListResponse response) {
          emit(GetCountriesLoaded(response: response));
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
