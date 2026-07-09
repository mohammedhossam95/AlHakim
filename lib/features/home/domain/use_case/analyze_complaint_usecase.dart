import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/home/data/models/analyze_complaint_request.dart';
import 'package:alhakim/features/home/data/models/analyze_complaint_response_model.dart';
import 'package:alhakim/features/home/domain/repo/home_repo.dart';
import 'package:dartz/dartz.dart';

class AnalyzeComplaintUseCase
    extends UseCase<AnalyzeComplaintResponse, AnalyzeComplaintRequest> {
  final HomeRepo repository;

  AnalyzeComplaintUseCase({required this.repository});

  @override
  Future<Either<Failure, AnalyzeComplaintResponse>> call(
    AnalyzeComplaintRequest request,
  ) async {
    return repository.analyzeComplaint(request);
  }
}
