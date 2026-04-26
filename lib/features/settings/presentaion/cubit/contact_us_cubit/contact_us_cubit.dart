import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/params/contact_us_param.dart';
import '/features/settings/domain/use_case/contact_us_use_case.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final ContactUsUseCase contactUsUseCase;
  ContactUsCubit(this.contactUsUseCase) : super(ContactUsInitial());

  Future<void> contactUsMethod(ContactUsParam param) async {
    emit(ContactUsLoading());
    try {
      final result = await contactUsUseCase.call(param);
      result.fold(
        (failure) => emit(ContactUsError(failure.message.toString())),
        (data) => emit(ContactUsSuccess(data)),
      );
    } catch (e) {
      emit(ContactUsError(e.toString()));
    }
  }
}
