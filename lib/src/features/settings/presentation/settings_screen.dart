import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/constants/strings.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/settings/presentation/setting_tile.dart';
import 'package:focusnest/src/features/settings/presentation/settings_screen_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
    installerStore: '',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userId = authRepository.currentUser?.uid;
    final userEmail = authRepository.currentUser?.email;

    ref.listen<AsyncValue>(
      settingsScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(settingsScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                SettingTile(
                  title: 'Account Settings',
                  subtitle: 'Manage your account settings and preferences',
                  icon: Icons.account_circle_outlined,
                  action: () {
                    if (userId != null) {
                      context.pushNamed(
                        RoutesName.accountSettings,
                        pathParameters: {
                          'userId': userId,
                        },
                        queryParameters: {
                          'userEmail': userEmail,
                        },
                      );
                    } else {
                      showOKAlert(
                        context: context,
                        title: 'Error',
                        content: 'User not login',
                      );
                    }
                  },
                ),
                const SettingTile(
                  title: 'Privacy Policy',
                  subtitle: 'Learn how we handle and protect your data',
                  icon: Icons.privacy_tip_outlined,
                ),
                const SettingTile(
                  title: 'Terms of Service',
                  subtitle: 'Understand your rights and obligations',
                  icon: Icons.description_outlined,
                ),
                const SettingTile(
                  title: 'Contact Us',
                  // TODO: Use real email
                  subtitle: 'Reach out to us at ${Strings.emailName}',
                  icon: Icons.mail_outline,
                  hasTrailingIcon: false,
                ),
                SettingTile(
                  title: 'App Version',
                  subtitle: 'Current app version: ${_packageInfo.version}',
                  icon: Icons.info_outline,
                  hasTrailingIcon: false,
                ),
              ],
            ),
            Spacers.mediumVertical,
            LinkTextButton(
              title: 'Sign Out',
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final logoutConfirmed = await showAlertDialog(
                        context: context,
                        title: 'Confirm Sign Out',
                        content:
                            'Are you sure you want to sign out of FocusNest? This will end your current session.',
                        defaultActionText: 'Yes',
                      );
                      if (logoutConfirmed == true) {
                        ref
                            .read(settingsScreenControllerProvider.notifier)
                            .signOut();
                      }

                      if (logoutConfirmed == true) {
                        ref
                            .read(settingsScreenControllerProvider.notifier)
                            .signOut();
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
