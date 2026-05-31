import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/domain/usecases/complete_profile_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  final CompleteProfileUsecase usecase;

  CompleteProfileCubit({required this.usecase})
    : super(CompleteProfileInitial());

  Future<void> completeProfile({required CompleteProfileParams params}) async {
    emit(CompleteProfileLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(CompleteProfileError(message: l.message ?? '')),
      (r) => emit(CompleteProfileSuccess(response: r)),
    );
  }
}
