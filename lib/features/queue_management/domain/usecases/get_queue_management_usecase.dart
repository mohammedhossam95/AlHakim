import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/queue_management/domain/repositories/queue_management_repository.dart';
import 'package:dartz/dartz.dart';

class GetQueueManagementUsecase {
  final QueueManagementRepository repository;

  GetQueueManagementUsecase({required this.repository});

  Future<Either<Failure, BaseListResponse>> call({
    required String doctorId,
  }) async {
    return await repository.getQueueManagement(doctorId: doctorId);
  }
}
