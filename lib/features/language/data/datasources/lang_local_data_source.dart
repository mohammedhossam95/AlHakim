import '/core/error/exceptions.dart';
import '/features/language/data/models/languages_resp_model.dart';
import '../../../../core/utils/enums.dart';
import '../../../../injection_container.dart';

abstract class LangLocalDataSource {
  Future<LanguagesRespModel> getRemoteLanguages();
  Future<bool> changeLang({required LanguageCode langCode});
  Future<LanguageCode> getSavedLang();
}

class LangLocalDataSourceImpl implements LangLocalDataSource {
  LangLocalDataSourceImpl();

  @override
  Future<LanguagesRespModel> getRemoteLanguages() async {
    try {
      const String getLanguagesEndpoints = '/languages';
      final response = await dioConsumer.get(
        getLanguagesEndpoints,
        queryParameters: {
          'per_page': 10,
          'page': 1,
        },
      );
      if (response['key'] == "success") {
        return LanguagesRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<bool> changeLang({required LanguageCode langCode}) async =>
      await sharedPreferences.saveLanguageCode(langCode.name);

  @override
  Future<LanguageCode> getSavedLang() async =>
      sharedPreferences.getLanguageCode();
}
