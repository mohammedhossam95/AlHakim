import 'dart:developer';

import 'package:alhakim/features/auth/domain/entities/auth_entity.dart';
import 'package:alhakim/injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/enums.dart';
import '../../../domain/usecases/get_session_usecase.dart';
import '../../../domain/usecases/save_session_usecase.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final GetSessionStatusUseCase getSessionStatus;
  final SaveSessionStatusUseCase saveSessionStatus;

  SessionCubit({
    required this.getSessionStatus,
    required this.saveSessionStatus,
  }) : super(const SessionState.initial());

  Future<void> resolveSession() async {
    final result = await getSessionStatus(NoParams());

    result.fold(
      (f) {
        debugPrint('SESSION FAILED: ${f.message}');
        emit(const SessionState(status: SessionStatus.guest));
      },
      (status) {
        debugPrint('SESSION LOADED: $status');
        emit(SessionState(status: status));
      },
    );
  }

  Future<void> completeOnboarding() async {
    await saveSessionStatus(SessionStatusParams(status: SessionStatus.guest));

    emit(const SessionState(status: SessionStatus.guest));
  }

  Future<void> loginSuccess(AuthEntity entity) async {
    await saveSessionStatus(
      SessionStatusParams(status: SessionStatus.authenticated),
    );
    await secureStorage.saveAccessToken(entity.token);
    log('done  token saved \t${entity.token}');
    emit(const SessionState(status: SessionStatus.authenticated));
  }

  Future<void> logout() async {
    await saveSessionStatus(SessionStatusParams(status: SessionStatus.guest));

    // Clear secure storage (tokens)
    secureStorage.clearAll();

    // Clear user data from SharedPreferences
    await sharedPreferences.removeUser();
    await sharedPreferences.removeUserId();

    // Clear guest addresses from SQLite
    // Note: Do NOT clear lastSyncedUserId or isAddressSynced
    // try {
    //   await DBHelper.deleteTableData();
    //   debugPrint('Guest addresses cleared on logout');
    // } catch (e) {
    //   debugPrint('Error clearing guest addresses: $e');
    // }

    emit(const SessionState(status: SessionStatus.guest));
  }
}
