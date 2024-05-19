import 'package:flutter/material.dart';
import 'package:focusnest/src/features/settings/presentation/setting_tile.dart';

class AccountSettingsScreen extends StatefulWidget {
  final String userId;
  final String userEmail;
  const AccountSettingsScreen({
    required this.userId,
    required this.userEmail,
    super.key,
  });

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                SettingTile(
                  title: 'Email',
                  subtitle: widget.userEmail,
                  icon: Icons.email_outlined,
                ),
                const SettingTile(
                  title: 'Change Password',
                  subtitle: 'Update your password for enhanced security',
                  icon: Icons.lock_outline,
                ),
                const SettingTile(
                  title: 'Delete Account',
                  subtitle:
                      'Permanently remove your account and all associated data',
                  icon: Icons.delete_forever_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
