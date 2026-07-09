import 'package:alhakim/features/home/data/models/analyze_complaint_request.dart';
import 'package:alhakim/features/home/domain/use_case/analyze_complaint_usecase.dart';
import 'package:alhakim/features/home/presentation/cubit/analyze_complaint_cubit/analyze_complaint_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyzeComplaintCubit extends Cubit<AnalyzeComplaintState> {
  final AnalyzeComplaintUseCase useCase;

  AnalyzeComplaintCubit({required this.useCase})
    : super(AnalyzeComplaintInitial());

  Future<void> analyzeComplaint({required String complaint}) async {
    emit(AnalyzeComplaintLoading());

    try {
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
