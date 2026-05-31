import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/booking/domain/repositories/booking_repository.dart';
import 'package:dartz/dartz.dart';

class GetFamilyMembersUsecase implements UseCase<BaseListResponse, NoParams> {
  final BookingRepository repository;

  GetFamilyMembersUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseListResponse>> call(NoParams params) async {
    return await repository.getFamilyMembers();
  }
}
