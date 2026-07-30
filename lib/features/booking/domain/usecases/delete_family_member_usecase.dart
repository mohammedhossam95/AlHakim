import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/booking/domain/repositories/booking_repository.dart';
import 'package:alhakim/features/booking/domain/usecases/params/delete_family_member_params.dart';
import 'package:dartz/dartz.dart';

class DeleteFamilyMemberUsecase {
  final BookingRepository repository;

  DeleteFamilyMemberUsecase({required this.repository});

  Future<Either<Failure, BaseOneResponse>> call(
    DeleteFamilyMemberParams params,
  ) async {
    return await repository.deleteFamilyMember(params: params);
  }
}
