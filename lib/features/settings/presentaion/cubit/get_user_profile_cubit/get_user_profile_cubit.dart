import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/settings/domain/use_case/get_user_profile_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';

part 'get_user_profile_state.dart';

class GetUserProfileCubit extends Cubit<GetUserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  GetUserProfileCubit({required this.getUserProfileUseCase})
    : super(GetUserProfileInitial());

  Future<void> getUserProfile(AuthParams params) async {
    emit(GetUserProfileIsLoading());
    try {
      final Either<Failure, BaseOneResponse> eitherResult =
          await getUserProfileUseCase(params);
      eitherResult.fold(
        (Failure failure) {
          emit(GetUserProfileError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
          emit(GetUserProfileLoaded(response: response));
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
