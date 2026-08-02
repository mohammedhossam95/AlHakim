import 'package:alhakim/features/booking/domain/usecases/book_appointment_usecase.dart';
import 'package:alhakim/features/booking/domain/usecases/params/booking_params.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:alhakim/core/base_classes/base_one_response.dart';

part 'book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final BookAppointmentUsecase usecase;

  BookAppointmentCubit({required this.usecase})
    : super(BookAppointmentInitial());

  Future<void> bookAppointment(BookingParams params) async {
    emit(BookAppointmentLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(BookAppointmentError(message: l.message ?? '')),
      (r) => emit(BookAppointmentSuccess(response: r)),
    );
  }
}
