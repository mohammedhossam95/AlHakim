import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/settings/domain/use_case/get_app_setting_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_setting_state.dart';

class AppSettingCubit extends Cubit<AppSettingState> {
  final GetAppSettingUsecase usecase;
  AppSettingCubit(this.usecase) : super(AppSettingInitial());
  Future<void> getAppsetting() async {
    emit(AppSettingLoading(isLoading: true));
    try {
      final eitherResponse = await usecase.call(NoParams());
      emit(AppSettingLoading(isLoading: false));
      eitherResponse.fold(
        (failure) => emit(AppSettingError(message: failure.message.toString())),
        (resp) => emit(AppSettingLoaded(resp: resp)),
      );
    } catch (e) {
      emit(AppSettingError(message: e.toString()));
    }
  }
}
