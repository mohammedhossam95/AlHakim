import 'package:alhakim/core/params/complete_profile_params.dart';
import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/settings/domain/use_case/update_user_profile_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';

part 'update_user_profile_state.dart';

class UpdateUserProfileCubit extends Cubit<UpdateUserProfileState> {
  final UpdateUserProfileUseCase udateUserProfileUseCase;

  UpdateUserProfileCubit({required this.udateUserProfileUseCase})
    : super(UpdateUserProfileInitial());
  bool isLoading = false;

  Future<void> updateUserProfile(CompleteProfileParams params) async {
    try {
      changeLoadingView();
      final Either<Failure, UserModel> eitherResult =
          await udateUserProfileUseCase(params);
      changeLoadingView();
      eitherResult.fold(
        (Failure failure) {
          emit(UpdateUserProfileError(failure.message ?? ''));
        },
        (UserModel response) {
          emit(UpdateUserProfileLoaded(response: response));
        },
      );
    } catch (e) {
      emit(UpdateUserProfileError(e.toString()));
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(UpdateUserProfileIsLoading(isLoading: isLoading));
  }
}
