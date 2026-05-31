import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/queue_management/domain/repositories/queue_management_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateQueueStatusUsecase {
  final QueueManagementRepository repository;

  UpdateQueueStatusUsecase({required this.repository});

  Future<Either<Failure, BaseOneResponse>> call({
    required String doctorId,
    required int appointmentId,
    required String status,
  }) async {
    return await repository.updateQueueStatus(
      doctorId: doctorId,
      appointmentId: appointmentId,
      status: status,
    );
  }
}
