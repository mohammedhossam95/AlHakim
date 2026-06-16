import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:alhakim/features/appointments/domain/usecases/params/get_queue_status_params.dart';
import 'package:dartz/dartz.dart';

class GetQueueStatusUsecase
    implements UseCase<BaseOneResponse, GetQueueStatusParams> {
  final AppointmentRepository repository;

  GetQueueStatusUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(
    GetQueueStatusParams params,
  ) async {
    return await repository.getQueueStatus(
      appointmentId: params.appointmentId,
    );
  }
}
