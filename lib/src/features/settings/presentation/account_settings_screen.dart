import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/features/settings/presentation/setting_tile.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:go_router/go_router.dart';

// Account Settings Screen for user to view their email, update password and delete their account
class AccountSettingsScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userEmail;

  const AccountSettingsScreen({
    required this.userId,
    required this.userEmail,
    super.key,
  });

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  void _handleDeleteUser() async {
    bool? confirmDelete = await showAlertDialog(
      context: context,
      title: 'Delete Account',
      defaultActionText: 'Continue',
      content:
          'Deleting your account is permanent. All your data will be wiped out immediately and you wont be able to get it back. Are you sure?',
    );

    if (confirmDelete == true && mounted) {
      context.pushNamed(
        RoutesName.verifyDeleteAccount,
        pathParameters: {
          'userId': widget.userId,
        },
        queryParameters: {
          'userEmail': widget.userEmail,
        },
      );
    }
  }

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
              physics: const NeverScrollableScrollPhysics(),
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
                SettingTile(
                  title: 'Delete Account',
                  subtitle:
                      'Permanently remove your account and all associated data',
                  icon: Icons.delete_forever_outlined,
                  action: _handleDeleteUser,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
