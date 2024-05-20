import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/constants/strings.dart';
import 'package:focusnest/src/routing/app_router.dart';
import 'package:focusnest/src/services/notification_controller.dart';
import 'package:focusnest/src/utils/theme.dart';

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
    NotificationController.startListeningNotificationEvents();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
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
