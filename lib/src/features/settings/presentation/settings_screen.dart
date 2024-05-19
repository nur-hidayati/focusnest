import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/settings/presentation/settings_screen_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/async_value_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              children: const [
                SettingTile(
                  title: 'Account Settings',
                  subtitle: 'Manage your account settings and preferences',
                  icon: Icons.account_box_outlined,
                ),
                SettingTile(
                  title: 'Privacy Policy',
                  subtitle: 'Learn how we handle and protect your data',
                  icon: Icons.lock_outline,
                ),
                SettingTile(
                  title: 'Terms of Service',
                  subtitle: 'Understand your rights and obligations',
                  icon: Icons.gavel_outlined,
                ),
                SettingTile(
                  title: 'Contact Us',
                  // TODO: Use real email
                  subtitle: 'Reach out to us at my_email@gmail.com',
                  icon: Icons.mail_outline,
                  hasTrailingIcon: false,
                ),
                SettingTile(
                  title: 'App Version',
                  subtitle: 'Current app version: 1.0.0',
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
