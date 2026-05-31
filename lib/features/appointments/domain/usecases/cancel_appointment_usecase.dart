import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:dartz/dartz.dart';

class CancelAppointmentUsecase implements UseCase<BaseOneResponse, String> {
  final AppointmentRepository repository;

  CancelAppointmentUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(String params) async {
    return await repository.cancelAppointment(appointmentId: params);
  }
}
