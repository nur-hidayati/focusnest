import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/constants/strings.dart';
import 'package:focusnest/src/routing/app_router.dart';
import 'package:focusnest/src/utils/theme.dart';

class App extends ConsumerWidget {
  final String flavor;

  const App({
    required this.flavor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
