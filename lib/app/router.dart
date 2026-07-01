import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/setup/presentation/pages/setup_config_page.dart';
import '../features/setup/presentation/pages/setup_network_page.dart';

/// Central route registry.
///
/// Route guards live in [_redirect]. Inject a [SetupStatusNotifier] (or
/// equivalent ChangeNotifier) via [refreshListenable] so GoRouter re-evaluates
/// guards whenever setup state changes.
abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.setupNetwork,
        name: 'setup-network',
        builder: (_, __) => const SetupNetworkPage(),
      ),
      GoRoute(
        path: AppRoutes.setupConfig,
        name: 'setup-config',
        builder: (_, __) => const SetupConfigPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (_, __) => const DashboardPage(),
      ),
    ],
  );

  /// Route guard.
  ///
  /// Returns null to allow navigation, or a path to redirect to.
  /// TODO: read setup status from an injected notifier and redirect
  ///       to [AppRoutes.setupNetwork] or [AppRoutes.setupConfig] when
  ///       setup is incomplete.
  static String? _redirect(BuildContext context, GoRouterState state) {
    return null;
  }
}

abstract final class AppRoutes {
  static const setupNetwork = '/setup/network';
  static const setupConfig = '/setup/config';
  static const dashboard = '/dashboard';
}
