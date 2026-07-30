import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/booking/domain/repositories/booking_repository.dart';
import 'package:alhakim/features/booking/domain/usecases/params/update_family_member_params.dart';
import 'package:dartz/dartz.dart';

class UpdateFamilyMemberUsecase {
  final BookingRepository repository;

  UpdateFamilyMemberUsecase({required this.repository});

  Future<Either<Failure, BaseOneResponse>> call(
    UpdateFamilyMemberParams params,
  ) async {
    return await repository.updateFamilyMember(params: params);
  }
}
