import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/settings/presentation/settings_screen_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';
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
                const SettingTile(
                  title: 'Account Settings',
                  subtitle: 'Manage your account settings and preferences',
                  icon: Icons.account_circle_outlined,
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
                  subtitle: 'Reach out to us at my_email@gmail.com',
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

class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool hasTrailingIcon;

  const SettingTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.hasTrailingIcon = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: hasTrailingIcon
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColor.lightGreyColor,
                )
              : null,
          onTap: () {
            // Handle your tile tap here
          },
        ),
      ],
    );
  }
}
