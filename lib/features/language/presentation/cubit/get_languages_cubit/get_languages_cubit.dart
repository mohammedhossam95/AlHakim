import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/values/strings.dart';
import '/core/base_classes/base_list_response.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/language/domain/usecases/get_available_languages.dart';

part 'get_languages_state.dart';

class GetLanguagesCubit extends Cubit<GetLanguagesState> {
  final GetLanguagesList getLanguagesList;
  GetLanguagesCubit({required this.getLanguagesList})
      : super(GetLanguagesInitial());
  bool isLoading = false;
  Future<void> getLanguages() async {
    changeLoadingView();
    try {
      Either<Failure, BaseListResponse> response =
          await getLanguagesList(NoParams());
      changeLoadingView();
      emit(response.fold(
        (failure) =>
            GetLanguagesError(msg: failure.message?? Strings.pleaseTryAgainLater),
        (response) {
          return GetLanguagesLoaded(response: response);
        },
      ));
    } catch (e) {
      emit(GetLanguagesError(msg: e.toString()));
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(GetLanguagesIsLoading(isLoading));
  }
}
