import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../injection_container.dart';
import '../../../domain/usecases/change_lang.dart';
import '../../../domain/usecases/get_saved_lang.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final GetSavedLangUseCase getSavedLangUseCase;
  final ChangeLangUseCase changeLangUseCase;

  LocaleCubit(
      {required this.getSavedLangUseCase, required this.changeLangUseCase})
      : super(LocaleState(Locale(sharedPreferences.getLanguageCode().name)));

  LanguageCode currentLangCode = sharedPreferences.getLanguageCode();

  Future<void> getSavedLang() async {
    final response = await getSavedLangUseCase(NoParams());
    response.fold(
      (failure) => debugPrint(AppStrings.cacheFailure),
      (value) {
        currentLangCode = value;
        emit(LocaleState(Locale(currentLangCode.name)));
      },
    );
  }

  void changeLanguage(LanguageCode langCode, BuildContext context) async{
    final response = await changeLangUseCase(langCode);
    response.fold(
          (failure) => debugPrint(AppStrings.cacheFailure),
          (value) {
        currentLangCode = langCode;
        final newLocal = Locale(currentLangCode.name);
        appLocalizations.load(locale: newLocal);
        dioConsumer.updateLanguageCodeHeader();
        emit(LocaleState(newLocal));
      },
    );
  }
}
