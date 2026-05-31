import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/params/quick_booking_params.dart';
import 'package:alhakim/features/queue_management/domain/usecases/quick_booking_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quick_booking_state.dart';

class QuickBookingCubit extends Cubit<QuickBookingState> {
  final QuickBookingUsecase usecase;

  QuickBookingCubit({required this.usecase}) : super(QuickBookingInitial());

  Future<void> quickBooking({required QuickBookingParams params}) async {
    emit(QuickBookingLoading());

    final result = await usecase(params);

    result.fold(
      (l) => emit(QuickBookingError(message: l.message ?? '')),
      (r) => emit(QuickBookingSuccess(response: r)),
    );
  }
}
