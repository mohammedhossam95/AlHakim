import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/params/quick_booking_params.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/queue_management/domain/repositories/queue_management_repository.dart';
import 'package:dartz/dartz.dart';

class QuickBookingUsecase
    implements UseCase<BaseOneResponse, QuickBookingParams> {
  final QueueManagementRepository repository;

  QuickBookingUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(
    QuickBookingParams params,
  ) async {
    return await repository.quickBooking(params: params);
  }
}
