import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/usecases/usecase.dart';
import '/features/settings/domain/entity/support_phone_response.dart';
import '/features/settings/domain/use_case/get_support_phone_use_case.dart';

part 'get_support_phone_state.dart';

class SupportPhoneCubit extends Cubit<SupportPhoneState> {
  final GetSupportPhoneUseCase getSupportPhoneUseCase;
  SupportPhoneCubit(this.getSupportPhoneUseCase)
    : super(SupportPhoneInitialState());
  var isLoading = false;
  Future<void> getData() async {
    changeLoadingView();
    try {
      final result = await getSupportPhoneUseCase(NoParams());
      changeLoadingView();
      result.fold(
        (failure) => emit(SupportPhoneErrorState(failure.message.toString())),
        (resp) => emit(SupportPhoneSuccessState(resp)),
      );
    } catch (e) {
      emit(SupportPhoneErrorState(e.toString()));
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(SupportPhoneLoadingState(isLoading: isLoading));
  }
}
