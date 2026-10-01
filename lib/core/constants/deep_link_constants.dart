/// Universal links and custom-scheme deep links for AlHakim.
abstract final class DeepLinkConstants {
  static const String webHost = 'alhakim-eg.com';
  static const String customScheme = 'alhakim';

  /// Public HTTPS path: `/doctor/{doctorId}/book`
  static String doctorBookingPath(String doctorId) =>
      '/doctor/${Uri.encodeComponent(doctorId)}/book';

  static String doctorBookingUniversalLink(String doctorId) =>
      'https://$webHost${doctorBookingPath(doctorId)}';

  /// Fallback when universal links are not verified yet.
  static String doctorBookingCustomSchemeLink(String doctorId) =>
      '$customScheme://doctor/${Uri.encodeComponent(doctorId)}/book';
}
