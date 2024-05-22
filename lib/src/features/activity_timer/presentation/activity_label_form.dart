import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_contents.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:go_router/go_router.dart';

// Bottom Sheet that display Activity Label Input with Cancel and Done header
class ActivityLabelForm extends ConsumerStatefulWidget {
  const ActivityLabelForm({
    super.key,
  });

  @override
  ConsumerState<ActivityLabelForm> createState() => _ActivityLabelFormState();
}

class _ActivityLabelFormState extends ConsumerState<ActivityLabelForm> {
  late TextEditingController activityLabelController;

  @override
  void initState() {
    super.initState();

    final authRepository = ref.read(authRepositoryProvider);
    final userId = authRepository.currentUser?.uid;

    if (userId != null) {
      activityLabelController = TextEditingController(
        text: ref.read(activityLabelProvider(userId)),
      );
    } else {
      activityLabelController = TextEditingController();
    }
  }

  @override
  void dispose() {
    activityLabelController.dispose();
    super.dispose();
  }

  void _handleOnDoneActivityLabelUpdate() {
    if (activityLabelController.text.isNotEmpty) {
      final authRepository = ref.read(authRepositoryProvider);
      final userId = authRepository.currentUser?.uid;

      if (userId != null) {
        ref
            .read(activityLabelProvider(userId).notifier)
            .updateActivityLabel(activityLabelController.text.trim());
        context.pop();
      } else {
        showOKAlert(
          context: context,
          title: 'Error',
          content: 'User not logged in',
        );
      }
    } else {
      showInvalidLabelAlert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContents(
      headerTitle: 'Edit',
      onDoneActivityLabelUpdate: () => _handleOnDoneActivityLabelUpdate(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: CustomTextFormField(
          label: 'Activity Label',
          controller: activityLabelController,
          hintText: 'Activity Label',
          isActivityLabel: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }
}
