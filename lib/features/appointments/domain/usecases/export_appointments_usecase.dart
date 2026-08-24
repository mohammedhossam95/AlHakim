import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:dartz/dartz.dart';

class ExportAppointmentsUsecase implements UseCase<List<int>, NoParams> {
  final AppointmentRepository repository;

  ExportAppointmentsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<int>>> call(NoParams params) async {
    return await repository.exportAppointments();
  }
}
