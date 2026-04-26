import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/get_setting_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_setting_state.dart';

class GetSettingCubit extends Cubit<GetSettingState> {
  final GetSettingUseCase getSettingUseCase;
  GetSettingCubit({required this.getSettingUseCase})
    : super(GetSettingInitial());

  Future<void> getSetting() async {
    emit(GetSettingLoading(isLoading: true));
    try {
      final eitherResponse = await getSettingUseCase.call(NoParams());
      emit(GetSettingLoading(isLoading: false));
      eitherResponse.fold(
        (failure) =>
            emit(GetSettingError(errorMessage: failure.message.toString())),
        (resp) => emit(GetSettingLoaded(resp: resp)),
      );
    } catch (e) {
      emit(GetSettingError(errorMessage: e.toString()));
    }
  }
}
