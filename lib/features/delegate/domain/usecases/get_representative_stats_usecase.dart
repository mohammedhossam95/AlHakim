import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/delegate/domain/repositories/representative_repository.dart';
import 'package:dartz/dartz.dart';

class GetRepresentativeStatsUsecase
    implements UseCase<BaseOneResponse, NoParams> {
  final RepresentativeStatsRepository repository;

  GetRepresentativeStatsUsecase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(NoParams params) async {
    return await repository.getRepresentativeStats();
  }
}
