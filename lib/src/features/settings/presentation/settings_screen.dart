import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
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
      body: CustomButton(
        title: 'Logout',
        isFullWidth: false,
        onPressed: state.isLoading
            ? null
            : () async {
                final logout = await showAlertDialog(
                  context: context,
                  title: 'Are you sure?',
                  defaultActionText: 'Logout',
                );
                if (logout == true) {
                  ref.read(settingsScreenControllerProvider.notifier).signOut();
                }
              },
      ),
    );
  }
}
