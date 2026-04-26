import 'package:dartz/dartz.dart';
import '/core/base_classes/base_list_response.dart';
import '/features/language/domain/repositories/lang_repository.dart';
import '/core/usecases/usecase.dart';
import '/core/error/failures.dart';

class GetLanguagesList implements UseCase<BaseListResponse, NoParams> {
  final LangRepository repository;

  GetLanguagesList({required this.repository});
  @override
  Future<Either<Failure, BaseListResponse>> call(NoParams params) =>
      repository.getLanguagesList();
}
