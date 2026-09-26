import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/home/domain/use_case/accept_ai_consent_usecase.dart';
import 'package:alhakim/features/home/domain/use_case/get_ai_consent_usecase.dart';
import 'package:alhakim/features/home/domain/use_case/revoke_ai_consent_usecase.dart';
import 'package:alhakim/features/home/presentation/cubit/ai_consent_cubit/ai_consent_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiConsentCubit extends Cubit<AiConsentState> {
  final GetAiConsentUseCase getAiConsentUseCase;
  final AcceptAiConsentUseCase acceptAiConsentUseCase;
  final RevokeAiConsentUseCase revokeAiConsentUseCase;

  AiConsentCubit({
    required this.getAiConsentUseCase,
    required this.acceptAiConsentUseCase,
    required this.revokeAiConsentUseCase,
  }) : super(AiConsentInitial());

  Future<void> checkConsent() async {
    emit(AiConsentLoading());
    try {
      final result = await getAiConsentUseCase(NoParams());
      result.fold(
        (Failure failure) => emit(AiConsentError(failure.message ?? '')),
        (consent) {
          if (consent.accepted) {
            emit(AiConsentGranted());
          } else {
            emit(AiConsentNotGranted());
          }
        },
      );
    } catch (e) {
      emit(AiConsentError(e.toString()));
    }
  }

  Future<void> accept() async {
    emit(AiConsentLoading());
    try {
      final result = await acceptAiConsentUseCase(NoParams());
      result.fold(
        (Failure failure) => emit(AiConsentError(failure.message ?? '')),
        (_) => emit(AiConsentGranted()),
      );
    } catch (e) {
      emit(AiConsentError(e.toString()));
    }
  }

  Future<void> revoke() async {
    emit(AiConsentLoading());
    try {
      final result = await revokeAiConsentUseCase(NoParams());
      result.fold(
        (Failure failure) => emit(AiConsentError(failure.message ?? '')),
        (_) => emit(AiConsentNotGranted()),
      );
    } catch (e) {
      emit(AiConsentError(e.toString()));
    }
  }
}
