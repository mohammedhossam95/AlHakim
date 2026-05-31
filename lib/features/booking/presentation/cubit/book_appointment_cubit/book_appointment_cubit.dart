import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/features/booking/domain/usecases/book_appointment_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final BookAppointmentUsecase usecase;

  BookAppointmentCubit({required this.usecase})
    : super(BookAppointmentInitial());

  Future<void> bookAppointment({
    required String doctorId,
    required String appointmentDate,
    String? familyMemberId,
  }) async {
    emit(BookAppointmentLoading());

    final result = await usecase(
      doctorId: doctorId,
      appointmentDate: appointmentDate,
      familyMemberId: familyMemberId,
    );

    result.fold(
      (l) => emit(BookAppointmentError(message: l.message ?? '')),
      (r) => emit(BookAppointmentSuccess(response: r)),
    );
  }
}
