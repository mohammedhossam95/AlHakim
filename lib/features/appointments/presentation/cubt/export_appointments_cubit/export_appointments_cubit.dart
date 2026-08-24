import 'dart:io';

import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/appointments/domain/usecases/export_appointments_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

part 'export_appointments_state.dart';

class ExportAppointmentsCubit extends Cubit<ExportAppointmentsState> {
  final ExportAppointmentsUsecase usecase;

  ExportAppointmentsCubit({required this.usecase})
    : super(ExportAppointmentsInitial());

  Future<void> exportAppointments() async {
    emit(ExportAppointmentsLoading());

    final result = await usecase(NoParams());

    await result.fold(
      (failure) async {
        emit(ExportAppointmentsError(message: failure.message ?? ''));
      },
      (bytes) async {
        try {
          final filePath = await _saveExcelFile(bytes);
          emit(ExportAppointmentsSuccess(filePath: filePath));
        } catch (e) {
          emit(ExportAppointmentsError(message: e.toString()));
        }
      },
    );
  }

  Future<String> _saveExcelFile(List<int> bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'appointments_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
