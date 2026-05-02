import 'dart:developer';

import 'package:alhakim/features/auth/domain/usecases/get_user_type_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/logout_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/save_user_type_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/usecases/usecase.dart';
import '/core/utils/enums.dart';
import '/injection_container.dart';
import '../../../domain/usecases/get_session_usecase.dart';
import '../../../domain/usecases/save_session_usecase.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required GetSessionStatusUseCase getSessionStatus,
    required SaveSessionStatusUseCase saveSessionStatus,
    required GetUserTypeUseCase getUserType,
    required SaveUserTypeUseCase saveUserType,
    required LogoutUseCase logoutUseCase,
  }) : _getSessionStatus = getSessionStatus,
       _saveSessionStatus = saveSessionStatus,
       _getUserType = getUserType,
       _saveUserType = saveUserType,
       _logoutUseCase = logoutUseCase,
       super(const SessionState.initial());

  final GetSessionStatusUseCase _getSessionStatus;
  final SaveSessionStatusUseCase _saveSessionStatus;
  final GetUserTypeUseCase _getUserType;
  final SaveUserTypeUseCase _saveUserType;
  final LogoutUseCase _logoutUseCase;

  Future<void> resolveSession() async {
    final result = await _getSessionStatus(NoParams());
    result.fold(
      (f) {
        log('SESSION FAILED: ${f.message}');
        emit(
          const SessionState(
            status: SessionStatus.firstLaunch,
            userType: UserType.patient,
          ),
        );
      },
      (status) async {
        log('SESSION LOADED: $status');
        final userTypeResult = await _getUserType(NoParams());
        userTypeResult.fold(
          (f) {
            log('USER TYPE FAILED: ${f.message}');
            emit(
              const SessionState(
                status: SessionStatus.firstLaunch,
                userType: UserType.patient,
              ),
            );
          },
          (userType) {
            emit(SessionState(status: status, userType: userType));
          },
        );
      },
    );
  }

  Future<void> setUserType(UserType userType) async {
    final result = await _saveUserType(UserTypeParams(userType: userType));
    result.fold((f) => log('SAVE USER TYPE FAILED: ${f.message}'), (s) {
      log('USER TYPE SAVED: $userType');
      emit(SessionState(status: SessionStatus.guest, userType: userType));
    });
  }

  Future<void> loginSuccess(UserType userType) async {
    await _saveSessionStatus(
      SessionStatusParams(status: SessionStatus.authenticated),
    );
    emit(SessionState(status: SessionStatus.authenticated, userType: userType));
  }

  Future<void> logout() async {
    final isTeacher = state.userType == UserType.patient;
    final result = await _logoutUseCase(LogoutParams(isTeacher: isTeacher));
    result.fold((f) => log('Logout API failed: ${f.message}'), (_) {});

    await _saveSessionStatus(SessionStatusParams(status: SessionStatus.guest));
    secureStorage.clearAll();
    await sharedPreferences.removeUser();
    await sharedPreferences.removeUserId();

    emit(state.copyWith(status: SessionStatus.guest));
  }
}
