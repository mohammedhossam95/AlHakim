import 'package:dartz/dartz.dart';
import '../../../../core/utils/enums.dart';
import '/core/base_classes/base_list_response.dart';
import '../../../../core/error/failures.dart';

abstract class LangRepository {
  Future<Either<Failure, BaseListResponse>> getLanguagesList();
  Future<Either<Failure, bool>> changeLang({required LanguageCode langCode});
  Future<Either<Failure, LanguageCode>> getSavedLang();
}
