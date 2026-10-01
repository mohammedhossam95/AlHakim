import 'dart:async';
import 'dart:developer';

import 'package:alhakim/config/routes/app_routes.dart';
import 'package:alhakim/config/routes/navigator_observer.dart';
import 'package:alhakim/core/deep_link/deep_link_parser.dart';
import 'package:app_links/app_links.dart';

/// Handles incoming app / universal links and navigates to booking.
class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  String? _pendingDoctorId;

  Future<void> initialize() async {
    await _linkSubscription?.cancel();

    try {
      final initialUri = await _appLinks.getInitialLink();
      _enqueueDoctorId(
        initialUri == null ? null : DeepLinkParser.parseDoctorBookingId(initialUri),
      );
    } catch (e, st) {
      log('DeepLinkService getInitialLink: $e', stackTrace: st);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        final doctorId = DeepLinkParser.parseDoctorBookingId(uri);
        if (doctorId == null) return;
        _pendingDoctorId = doctorId;
        navigateIfReady();
      },
      onError: (Object e, StackTrace st) {
        log('DeepLinkService uriLinkStream: $e', stackTrace: st);
      },
    );
  }

  void _enqueueDoctorId(String? doctorId) {
    if (doctorId == null || doctorId.isEmpty) return;
    _pendingDoctorId = doctorId;
  }

  /// Call after splash (or auth gate) has finished routing into the app.
  void onAppReadyForDeepLinks() {
    navigateIfReady();
  }

  void navigateIfReady() {
    final doctorId = _pendingDoctorId;
    if (doctorId == null || doctorId.isEmpty) return;

    final context = routeObserver.context;
    if (context == null || !context.mounted) return;

    final currentRoute = routeObserver.currentRoute;
    if (currentRoute == Routes.initialRoute) return;

    _pendingDoctorId = null;

    Routes.router.pushNamed(
      Routes.doctorBookingDeepLinkRoute,
      pathParameters: {'doctorId': doctorId},
    );
  }

  Future<void> dispose() async {
    await _linkSubscription?.cancel();
    _linkSubscription = null;
  }
}
