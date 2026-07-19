import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/auth_params.dart';
import 'package:alhakim/features/auth/data/models/check_account_resp_model.dart';
import 'package:alhakim/features/auth/domain/usecases/check_account_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';

part 'check_account_state.dart';

class CheckAccountCubit extends Cubit<CheckAccountState> {
  final CheckAccountUseCase checkAccountUseCase;

  CheckAccountCubit({required this.checkAccountUseCase})
    : super(const CheckAccountInitial());

  Future<void> checkAccount(AuthParams params) async {
    if (state is CheckAccountLoading) {
      return;
    }

    final phoneNumber = params.phoneNumber?.trim() ?? '';
    final countryCode = params.countryCode?.trim() ?? '';
    final userType = params.userType;

    if (phoneNumber.isEmpty) {
      emit(const CheckAccountFailure(message: 'Phone number is required.'));
      return;
    }

    if (countryCode.isEmpty) {
      emit(const CheckAccountFailure(message: 'Country code is required.'));
      return;
    }

    if (userType == null) {
      emit(const CheckAccountFailure(message: 'User type is required.'));
      return;
    }

    emit(const CheckAccountLoading());

    final Either<Failure, BaseOneResponse> eitherResult =
        await checkAccountUseCase(
          AuthParams(
            phoneNumber: phoneNumber,
            countryCode: countryCode,
            userType: userType,
            firebaseToken: params.firebaseToken,
            otp: params.otp,
            secretaryPhone: params.secretaryPhone,
            secretaryCountryCode: params.secretaryCountryCode,
          ),
        );

    eitherResult.fold(
      (Failure failure) {
        emit(CheckAccountFailure(message: failure.message ?? ''));
      },
      (BaseOneResponse response) {
        final data = response.data is CheckAccountData
            ? response.data as CheckAccountData
            : null;
        emit(
          CheckAccountSuccess(
            exists: data?.exists ?? false,
            message: response.message ?? '',
          ),
        );
      },
    );
  }
}
