import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/activity_calendar_screen.dart';
import 'package:focusnest/src/features/activity_timer/presentation/activity_timer_screen.dart';
import 'package:focusnest/src/features/activity_timer/presentation/timer_done_screen.dart';
import 'package:focusnest/src/features/activity_timer/presentation/timer_start_screen.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_screen.dart';
import 'package:focusnest/src/features/authentication/presentation/email_sent_screen.dart';
import 'package:focusnest/src/features/authentication/presentation/reset_password_screen.dart';
import 'package:focusnest/src/features/settings/presentation/account_settings_screen.dart';
import 'package:focusnest/src/features/settings/presentation/change_password_screen.dart';
import 'package:focusnest/src/features/settings/presentation/settings_screen.dart';
import 'package:focusnest/src/features/settings/presentation/verify_delete_account_screen.dart';
import 'package:focusnest/src/routing/scaffold_with_nested_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// Setup the routing using GoRouter with nested navigation support.
// Defines routes for authentication, activity calendar, activity timer, and settings.
// GoRouter instance manages navigation state and redirects based on user authentication status
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _activityTimerNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: RoutesName.activityTimer);
final _activityCalendarNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: RoutesName.activityCalendar);
final _settingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: RoutesName.settings);
const activityTimerPath = '/activity-timer';

enum AppRoute {
  auth,
  activityCalendar,
  timer,
  settings,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: activityTimerPath,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          _activityCalendarRoute(),
          _activityTimerRoute(),
          _settingsRoute(),
        ],
      )
    ],
  );
}

StatefulShellBranch _activityCalendarRoute() {
  return StatefulShellBranch(
    navigatorKey: _activityCalendarNavigatorKey,
    routes: [
      GoRoute(
        path: '/activity-calendar',
        name: RoutesName.activityCalendar,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ActivityCalendarScreen(),
        ),
      ),
    ],
  );
}

StatefulShellBranch _activityTimerRoute() {
  return StatefulShellBranch(
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
            name: RoutesName.timerStart,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) {
              final userId = state.uri.queryParameters['userId']!;
              final durationInSeconds =
                  int.tryParse(state.uri.queryParameters['duration'] ?? '0') ??
                      0;
              final duration = Duration(seconds: durationInSeconds);
              final label = state.uri.queryParameters['label']!;
              final timerSessionId =
                  state.uri.queryParameters['timerSessionId']!;
              return _buildCustomTransitionPage(
                TimerStartScreen(
                  userId: userId,
                  duration: duration,
                  label: label,
                  timerSessionId: timerSessionId,
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'timer-done',
                name: RoutesName.timerDone,
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  final durationInSeconds = int.tryParse(
                          state.uri.queryParameters['duration'] ?? '0') ??
                      0;
                  final duration = Duration(seconds: durationInSeconds);
                  final playSound =
                      state.uri.queryParameters['playSound'] == 'true';
                  return NoTransitionPage(
                    child: TimerDoneScreen(
                      duration: duration,
                      playSound: playSound,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch _settingsRoute() {
  return StatefulShellBranch(
    navigatorKey: _settingsNavigatorKey,
    routes: [
      GoRoute(
        path: '/settings',
        name: RoutesName.settings,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SettingsScreen(),
        ),
        routes: [
          GoRoute(
            path: 'auth',
            name: RoutesName.auth,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => _buildBottomTransitionPage(
                const AuthScreen(formType: AuthFormType.register)),
            routes: [
              GoRoute(
                path: 'reset-password',
                name: RoutesName.resetPassword,
                pageBuilder: (context, state) => _buildCustomTransitionPage(
                  const ResetPasswordScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':userEmail-sent',
                    name: RoutesName.emailSent,
                    pageBuilder: (context, state) {
                      final userEmail = state.pathParameters['userEmail']!;
                      return _buildCustomTransitionPage(
                        EmailSentScreen(
                          userEmail: userEmail,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: ':userId-account',
            name: RoutesName.accountSettings,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) {
              final userId = state.pathParameters['userId']!;
              final userEmail = state.uri.queryParameters['userEmail']!;
              return _buildCustomTransitionPage(
                AccountSettingsScreen(
                  userId: userId,
                  userEmail: userEmail,
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'change-password',
                name: RoutesName.changePassword,
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  final userEmail = state.uri.queryParameters['userEmail']!;
                  return _buildBottomTransitionPage(
                    ChangePasswordScreen(
                      userId: userId,
                      userEmail: userEmail,
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'verify-delete',
                name: RoutesName.verifyDeleteAccount,
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  final userEmail = state.uri.queryParameters['userEmail']!;

                  return _buildBottomTransitionPage(
                    VerifyDeleteAccount(
                      userId: userId,
                      userEmail: userEmail,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Custom page transition from right to left
CustomTransitionPage<void> _buildCustomTransitionPage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

// Custom page transition from bottom to top
CustomTransitionPage<void> _buildBottomTransitionPage(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
