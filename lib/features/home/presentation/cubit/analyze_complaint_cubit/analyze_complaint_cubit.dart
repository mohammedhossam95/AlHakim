import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/core/utils/log_utils.dart';
import 'package:alhakim/features/home/data/models/analyze_complaint_request.dart';
import 'package:alhakim/features/home/domain/use_case/analyze_complaint_usecase.dart';
import 'package:alhakim/features/home/domain/use_case/get_ai_consent_usecase.dart';
import 'package:alhakim/features/home/presentation/cubit/analyze_complaint_cubit/analyze_complaint_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyzeComplaintCubit extends Cubit<AnalyzeComplaintState> {
  final AnalyzeComplaintUseCase useCase;
  final GetAiConsentUseCase getAiConsentUseCase;

  AnalyzeComplaintCubit({
    required this.useCase,
    required this.getAiConsentUseCase,
  }) : super(AnalyzeComplaintInitial());

  Future<void> analyzeComplaint({required String complaint}) async {
    try {
      final consentResult = await getAiConsentUseCase(NoParams());
      final granted = consentResult.fold(
        (_) => false,
        (consent) => consent.accepted,
      );
      if (!granted) {
        Log.e('[analyzeComplaint] blocked: AI consent not granted');
        emit(AnalyzeComplaintConsentRequired());
        return;
      }

      emit(AnalyzeComplaintLoading());

      final result = await useCase.call(
        AnalyzeComplaintRequest(complaint: complaint),
      );

      result.fold(
        (failure) => emit(AnalyzeComplaintError(failure.message ?? '')),
        (response) => emit(AnalyzeComplaintSuccess(response: response)),
      );
    } catch (e) {
      emit(AnalyzeComplaintError(e.toString()));
    }
  }
}
