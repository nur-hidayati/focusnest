import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/main_common.dart';
import 'package:focusnest/src/constants/strings.dart';
import 'package:focusnest/src/routing/app_router.dart';
import 'package:focusnest/src/services/notification_controller.dart';
import 'package:focusnest/src/utils/theme.dart';

// Main application widget - configured to support different flavors
class App extends ConsumerStatefulWidget {
  final String flavor;

  const App({
    required this.flavor,
    super.key,
  });

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    // Start listening to notification events as soon as the app initializes
    NotificationController.startListeningNotificationEvents();

    // Remove the splash screen once the initial frame is rendered
    Future.delayed(Duration.zero, () {
      removeSplashScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp.router(
        routerConfig: goRouter,
        theme: appTheme(),
        title: Strings.appName,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
