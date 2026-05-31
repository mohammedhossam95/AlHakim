import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/features/booking/domain/repositories/booking_repository.dart';
import 'package:dartz/dartz.dart';

class AddFamilyMemberUsecase {
  final BookingRepository repository;

  AddFamilyMemberUsecase({required this.repository});

  Future<Either<Failure, BaseOneResponse>> call({
    required String fullName,
    required String birthDate,
    required String kinship,
  }) async {
    return await repository.addFamilyMember(
      fullName: fullName,
      birthDate: birthDate,
      kinship: kinship,
    );
  }
}
