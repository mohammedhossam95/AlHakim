// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/settings/domain/use_case/get_common_questions_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'common_questions_state.dart';

class CommonQuestionsCubit extends Cubit<CommonQuestionsState> {
  final GetCommonQuestionsUseCase getCommonQuestionsUseCase;
  CommonQuestionsCubit(this.getCommonQuestionsUseCase)
    : super(CommonQuestionsInitial());

  Future<void> getCommonQuestions() async {
    emit(CommonQuestionsLoading(isLoading: true));
    try {
      final eitherResponse = await getCommonQuestionsUseCase.call(NoParams());
      emit(CommonQuestionsLoading(isLoading: false));
      eitherResponse.fold(
        (failure) => emit(CommonQuestionsError(failure.message.toString())),
        (resp) => emit(CommonQuestionsLoaded(resp)),
      );
    } catch (e) {
      emit(CommonQuestionsError(e.toString()));
    }
  }
}
