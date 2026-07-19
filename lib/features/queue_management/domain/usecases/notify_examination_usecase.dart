import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/queue_management/domain/repositories/queue_management_repository.dart';
import 'package:dartz/dartz.dart';

class NotifyExaminationUsecase {
  final QueueManagementRepository repository;

  NotifyExaminationUsecase({required this.repository});

  Future<Either<Failure, BaseOneResponse>> call({
    required String appointmentId,
  }) async {
    return await repository.notifyExamination(appointmentId: appointmentId);
  }
}
