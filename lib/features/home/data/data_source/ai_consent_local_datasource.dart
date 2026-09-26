import 'package:alhakim/core/error/exceptions.dart';
import 'package:alhakim/features/home/domain/entity/ai_consent_entity.dart';
import 'package:alhakim/injection_container.dart';

abstract class AiConsentLocalDataSource {
  Future<AiConsent> getConsent();
  Future<void> acceptConsent();
  Future<void> revokeConsent();
}

class AiConsentLocalDataSourceImpl implements AiConsentLocalDataSource {
  static const AiConsent _rejected = AiConsent(accepted: false);

  @override
  Future<AiConsent> getConsent() async {
    try {
      final accepted = sharedPreferences.getAiConsentAccepted();
      if (!accepted) {
        return _rejected;
      }

      final acceptedAtRaw = sharedPreferences.getAiConsentAcceptedAt();
      if (acceptedAtRaw == null || acceptedAtRaw.isEmpty) {
        return _rejected;
      }

      final acceptedAt = DateTime.tryParse(acceptedAtRaw);
      if (acceptedAt == null) {
        return _rejected;
      }

      return AiConsent(accepted: true, acceptedAt: acceptedAt);
    } catch (_) {
      return _rejected;
    }
  }

  @override
  Future<void> acceptConsent() async {
    try {
      final acceptedSaved = await sharedPreferences.saveAiConsentAccepted(true);
      final atSaved = await sharedPreferences.saveAiConsentAcceptedAt(
        DateTime.now().toUtc().toIso8601String(),
      );
      if (!acceptedSaved || !atSaved) {
        throw const CacheException(message: '');
      }
    } on AppException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> revokeConsent() async {
    try {
      final acceptedRemoved = await sharedPreferences.removeAiConsentAccepted();
      final atRemoved = await sharedPreferences.removeAiConsentAcceptedAt();
      if (!acceptedRemoved || !atRemoved) {
        throw const CacheException(message: '');
      }
    } on AppException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }
}
