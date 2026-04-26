import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/utils/enums.dart';
import 'package:alhakim/features/settings/domain/use_case/get_static_page_content_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'static_page_content_state.dart';

class StaticPageContentCubit extends Cubit<StaticPageContentState> {
  final GetStaticPageContentUsecase useCase;
  StaticPageContentCubit(this.useCase) : super(StaticPageContentInitial());
  Future<void> getSataicPageContent(StaticPageType type) async {
    emit(StaticPageContentLoading(isLoading: true));
    try {
      final eitherResponse = await useCase.call(type);
      emit(StaticPageContentLoading(isLoading: false));
      eitherResponse.fold(
        (failure) =>
            emit(StaticPageContentError(message: failure.message.toString())),
        (resp) => emit(StaticPageContentLoaded(resp: resp)),
      );
    } catch (e) {
      emit(StaticPageContentError(message: e.toString()));
    }
  }
}
