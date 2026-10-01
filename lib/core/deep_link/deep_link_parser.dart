import 'package:alhakim/core/constants/deep_link_constants.dart';

abstract final class DeepLinkParser {
  DeepLinkParser._();

  /// Returns doctor id when [uri] matches a doctor booking deep link.
  static String? parseDoctorBookingId(Uri uri) {
    final queryId = uri.queryParameters['doctorId']?.trim();
    if (queryId != null && queryId.isNotEmpty) {
      return queryId;
    }

    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

    final doctorSegmentIndex = segments.indexOf('doctor');
    if (doctorSegmentIndex != -1 &&
        doctorSegmentIndex + 1 < segments.length) {
      final id = Uri.decodeComponent(segments[doctorSegmentIndex + 1]).trim();
      if (id.isNotEmpty) {
        return id;
      }
    }

    // alhakim://doctor/{id}/book → host "doctor", path /{id}/book
    if (uri.scheme == DeepLinkConstants.customScheme &&
        uri.host == 'doctor' &&
        segments.isNotEmpty) {
      final id = Uri.decodeComponent(segments.first).trim();
      if (id.isNotEmpty) {
        return id;
      }
    }

    if (!_isSupportedDeepLinkUri(uri)) {
      return null;
    }

    return null;
  }

  static bool _isSupportedDeepLinkUri(Uri uri) {
    if (uri.scheme == DeepLinkConstants.customScheme) {
      return true;
    }
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      return uri.host == DeepLinkConstants.webHost ||
          uri.host.endsWith('.${DeepLinkConstants.webHost}');
    }
    return false;
  }
}
