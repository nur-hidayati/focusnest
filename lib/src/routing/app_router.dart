import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/activity_calendar_screen.dart';
import 'package:focusnest/src/features/activity_timer/presentation/activity_timer_screen.dart';
import 'package:focusnest/src/features/activity_timer/presentation/timer_start_screen.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_screen.dart';
import 'package:focusnest/src/features/settings/presentation/settings_screen.dart';
import 'package:focusnest/src/routing/go_router_refresh_stream.dart';
import 'package:focusnest/src/routing/scaffold_with_nested_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _activityTimerNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: RoutesName.activityTimer);
final _activityCalendarNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: RoutesName.activityCalendar);
final _settingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: RoutesName.settings);

enum AppRoute {
  auth,
  activityCalendar,
  timer,
  settings,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  const authPath = '/auth';
  const activityTimerPath = '/activity-timer';
  const activityCalendarPath = '/activity-calendar';
  const settingsPath = '/settings';
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: authPath,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path.startsWith(authPath)) {
          return activityTimerPath;
        }
      } else {
        if (path.startsWith(activityTimerPath) ||
            path.startsWith(activityCalendarPath) ||
            path.startsWith(settingsPath)) {
          return authPath;
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: authPath,
        name: RoutesName.auth,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AuthScreen(formType: AuthFormType.register),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _activityCalendarNavigatorKey,
            routes: [
              GoRoute(
                path: activityCalendarPath,
                name: RoutesName.activityCalendar,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ActivityCalendarScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _activityTimerNavigatorKey,
            routes: [
              GoRoute(
                  path: activityTimerPath,
                  name: RoutesName.activityTimer,
                  pageBuilder: (context, state) => const NoTransitionPage(
                        child: ActivityTimerScreen(),
                      ),
                  routes: [
                    GoRoute(
                      path: 'timer-start',
                      parentNavigatorKey: _rootNavigatorKey,
                      name: RoutesName.timerStart,
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: TimerStartScreen(),
                      ),
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: settingsPath,
                name: RoutesName.settings,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      )
    ],
  );
}
