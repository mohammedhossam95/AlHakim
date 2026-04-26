import 'package:flutter/cupertino.dart' show CupertinoPage;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// iOS: [CupertinoPage] enables interactive edge swipe-back. Android / web: [MaterialPage].
Page<void> buildAdaptivePage({
  required GoRouterState state,
  required Widget child,
}) {
  final useCupertino = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  if (useCupertino) {
    return CupertinoPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
    );
  }
  return MaterialPage<void>(key: state.pageKey, name: state.name, child: child);
}
