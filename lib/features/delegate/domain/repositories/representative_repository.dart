
import 'package:alhakim/core/base_classes/base_one_response.dart';
import 'package:alhakim/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class RepresentativeStatsRepository {
  Future<Either<Failure, BaseOneResponse>>
      getRepresentativeStats();
}