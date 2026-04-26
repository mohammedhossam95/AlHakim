import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
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

  Future<void> updateUserProfile(AuthParams params) async {
    try {
      changeLoadingView();
      final Either<Failure, BaseOneResponse> eitherResult =
          await udateUserProfileUseCase(params);
      changeLoadingView();
      eitherResult.fold(
        (Failure failure) {
          emit(UpdateUserProfileError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
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
