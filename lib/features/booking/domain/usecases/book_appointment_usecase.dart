import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/booking/domain/repositories/booking_repository.dart';
import 'package:alhakim/features/booking/domain/usecases/params/booking_params.dart';
import 'package:dartz/dartz.dart';

class BookAppointmentUsecase {
  final BookingRepository repository;

  BookAppointmentUsecase({required this.repository});

  Future<Either<Failure, BaseOneResponse>> call(BookingParams params) async {
    return await repository.bookAppointment(params);
  }
}
