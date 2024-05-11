import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_screen.dart';
import 'package:focusnest/src/utils/theme.dart';

class App extends StatelessWidget {
  final String flavor;

  const App({
    required this.flavor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          title: 'FocusNest',
          debugShowCheckedModeBanner: false,
          home: const AuthScreen(
            formType: AuthFormType.register,
          ),
          theme: appTheme(),
        ),
      ),
    );
  }
}
