import 'package:flutter/material.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/features/settings/presentation/setting_tile.dart';
import 'package:go_router/go_router.dart';

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
                  hasTrailingIcon: false,
                ),
                SettingTile(
                  title: 'Change Password',
                  subtitle: 'Update your password for enhanced security',
                  icon: Icons.lock_outline,
                  action: () => context.pushNamed(
                    RoutesName.changePassword,
                    pathParameters: {
                      'userId': widget.userId,
                    },
                    queryParameters: {
                      'userEmail': widget.userEmail,
                    },
                  ),
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
