import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/params/change_password_params.dart';
import '/features/settings/domain/use_case/setting_use_case.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final SettingUseCase settingUseCase;
  ChangePasswordCubit(this.settingUseCase)
    : super(ChangePasswordInitialState());
  Future<void> changePassword(ChangePasswordParams params) async {
    emit(ChangePasswordLoadingState());
    try {
      final result = await settingUseCase.call(params);
      result.fold(
        (failure) =>
            emit(ChangePasswordErrorState(message: failure.message.toString())),
        (response) => emit(ChangePasswordSuccessState(resp: response)),
      );
    } catch (e) {
      emit(ChangePasswordErrorState(message: e.toString()));
    }
  }
}
