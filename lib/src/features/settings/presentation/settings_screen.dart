import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/common_widgets/loading_manager.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/constants/strings.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_controller.dart';
import 'package:focusnest/src/features/settings/presentation/setting_tile.dart';
import 'package:focusnest/src/features/settings/presentation/settings_screen_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';
import 'package:focusnest/src/utils/navigation_helper.dart';
import 'package:go_router/go_router.dart';

// Main settings screen that displays various settings options to the user.
// This screen includes account settings, privacy policy, terms of service,
// contact information, and app version details. It also provides a sign-out
// option for the user.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void _handleNavigateToUserSettings(String userId, String userEmail) {
    context.pushNamed(
      RoutesName.accountSettings,
      pathParameters: {
        'userId': userId,
      },
      queryParameters: {
        'userEmail': userEmail,
      },
    );
  }

  void _handleNavigateToAuth() {
    context.pushNamed(RoutesName.auth);
  }

  void openAppSettings() async {
    bool? confirmToSettings = await showAlertDialog(
      context: context,
      defaultActionText: 'Go To Settings',
      title: 'Change Font Size',
      content:
          'To adjust display and text size for FocusNest, go to Accessibility in your device settings, select "Per-App Settings", and add FocusNest. You can then customize the display and text size.',
    );
    if (confirmToSettings == true) {
      const url = 'app-settings:';
      launchURL(url);
    }
  }

  void _handleSignOut() async {
    final logoutConfirmed = await showAlertDialog(
      context: context,
      title: 'Confirm Sign Out',
      content:
          'Are you sure you want to sign out of FocusNest? This will end your current session.',
      defaultActionText: 'Yes',
    );
    if (logoutConfirmed == true) {
      ref.read(settingsScreenControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userId = authRepository.currentUser?.uid ?? Strings.tempUser;
    final userEmail = authRepository.currentUser?.email;

    ref.listen<AsyncValue>(
      settingsScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final settingsState = ref.watch(settingsScreenControllerProvider);
    final authState = ref.watch(authControllerProvider);

    return LoadingManager(
      isLoading: settingsState.isLoading || authState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  if (userId != Strings.tempUser) ...[
                    SettingTile(
                      title: 'Account Settings',
                      subtitle: 'Manage your account settings',
                      icon: Icons.account_circle_outlined,
                      action: () =>
                          _handleNavigateToUserSettings(userId, userEmail!),
                    ),
                  ] else ...[
                    SettingTile(
                      title: 'Sign Up Or Login',
                      subtitle: 'Create or access your account',
                      icon: Icons.login_outlined,
                      action: () => _handleNavigateToAuth(),
                    ),
                  ],
                  if (Platform.isIOS)
                    SettingTile(
                      title: 'Font Size',
                      subtitle: 'Set your preferred font size',
                      icon: Icons.format_size_outlined,
                      action: openAppSettings,
                    ),
                  SettingTile(
                    title: 'Privacy Policy',
                    subtitle: 'Learn how we handle and protect your data',
                    icon: Icons.privacy_tip_outlined,
                    action: () =>
                        launchURL('https://focusnest-app.github.io/focusnest/'),
                  ),
                  SettingTile(
                    title: 'Terms of Service',
                    subtitle: 'Understand your rights and obligations',
                    icon: Icons.description_outlined,
                    action: () => launchURL(
                        'https://focusnest-app.github.io/focusnest/terms_of_use'),
                  ),
                  const SettingTile(
                    title: 'Contact Us',
                    subtitle: Strings.emailName,
                    icon: Icons.mail_outline,
                    hasTrailingIcon: false,
                  ),
                  const SettingTile(
                    title: 'App Version',
                    // TODO: USE PACKAGE_INFO_PLUS TO DISPLAY VERSION IN NEXT RELEASE
                    subtitle: 'Current app version: 1.0.0',
                    icon: Icons.info_outline,
                    hasTrailingIcon: false,
                  ),
                ],
              ),
              if (userId != Strings.tempUser) ...[
                Spacers.mediumVertical,
                LinkTextButton(
                  title: 'Sign Out',
                  onPressed: _handleSignOut,
                )
              ],
              Spacers.largeVertical,
            ],
          ),
        ),
      ),
    );
  }
}
