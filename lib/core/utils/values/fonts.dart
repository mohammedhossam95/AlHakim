abstract class Fonts {
  static const String cairo = 'Cairo';
  static const String inter = 'Inter';

  static String forLocale(String languageCode) {
    return languageCode == 'ar' ? cairo : inter;
  }
}
