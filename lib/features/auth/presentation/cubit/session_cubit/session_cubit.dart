import 'dart:developer';

import 'package:alhakim/features/auth/data/models/auth_resp_model.dart';
import 'package:alhakim/features/auth/domain/usecases/get_user_type_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/logout_usecase.dart';
import 'package:alhakim/features/auth/domain/usecases/save_user_type_usecase.dart';
import 'package:alhakim/features/doctors/domain/entities/doctor_entity.dart';
import 'package:alhakim/features/doctors/domain/entities/profile_entity.dart';
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

  SessionState _buildAuthenticatedState(UserType userType) {
    if (userType != UserType.doctor) {
      return SessionState(
        status: SessionStatus.authenticated,
        userType: userType,
        error: null,
      );
    }

    final auth = sharedPreferences.getAuth();
    return _buildDoctorSessionState(auth);
  }

  SessionState _buildDoctorSessionState(AuthModel? auth) {
    final isMedicalCenter = auth?.role == 'medical_center';

    if (isMedicalCenter) {
      return SessionState(
        status: SessionStatus.authenticated,
        userType: UserType.doctor,
        doctorAccountMode: DoctorAccountMode.medicalCenter,
        activeDoctorId: null,
        selectedDoctor: null,
        userProfile: auth?.profile,
        error: null,
      );
    }

    return SessionState(
      status: SessionStatus.authenticated,
      userType: UserType.doctor,
      doctorAccountMode: DoctorAccountMode.singleDoctor,
      activeDoctorId: auth?.doctor?.id,
      selectedDoctor: null,
      userProfile: null,
      error: null,
    );
  }

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
            if (status == SessionStatus.authenticated) {
              emit(_buildAuthenticatedState(userType));
            } else {
              emit(SessionState(status: status, userType: userType));
            }
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
    emit(_buildAuthenticatedState(userType));
  }

  void selectDoctorForMedicalCenter(DoctorEntity doctor) {
    emit(
      state.copyWith(
        activeDoctorId: doctor.id,
        selectedDoctor: doctor,
      ),
    );
  }

  void clearSelectedDoctor() {
    if (state.doctorAccountMode != DoctorAccountMode.medicalCenter) return;

    emit(state.copyWith(clearSelectedDoctor: true));
  }

  Future<void> logout() async {
    try {
      final result = await _logoutUseCase(NoParams());

      result.fold(
        (failure) => log('Logout API failed: ${failure.message}'),
        (_) {},
      );

      await sharedPreferences.removeUser();
      await sharedPreferences.removeUserId();
      await sharedPreferences.removeUserType();

      await secureStorage.clearAll();

      final guestResult = await _saveSessionStatus(
        SessionStatusParams(status: SessionStatus.guest),
      );

      guestResult.fold(
        (failure) => log('SAVE GUEST SESSION FAILED: ${failure.message}'),
        (_) {},
      );

      emit(
        const SessionState(
          status: SessionStatus.guest,
          userType: UserType.patient,
          error: null,
        ),
      );
    } catch (e) {
      log('Logout failed unexpectedly: $e');

      emit(
        const SessionState(
          status: SessionStatus.guest,
          userType: UserType.patient,
          error: null,
        ),
      );
    }
  }
}
