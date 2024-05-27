import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_contents.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/constants/strings.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';

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
    final userId = authRepository.currentUser?.uid ?? Strings.tempUser;

    activityLabelController = TextEditingController(
      text: ref.read(activityLabelProvider(userId)),
    );
  }

  @override
  void dispose() {
    activityLabelController.dispose();
    super.dispose();
  }

  void _handleOnDoneActivityLabelUpdate() {
    if (activityLabelController.text.isNotEmpty) {
      final authRepository = ref.read(authRepositoryProvider);
      final userId = authRepository.currentUser?.uid ?? Strings.tempUser;

      ref
          .read(activityLabelProvider(userId).notifier)
          .updateActivityLabel(activityLabelController.text.trim());
    } else {
      showInvalidLabelAlert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContents(
      headerTitle: 'Edit',
      onDoneActivityLabelUpdate: () => _handleOnDoneActivityLabelUpdate(),
      child: CustomTextFormField(
        label: 'Activity Label',
        controller: activityLabelController,
        hintText: 'Activity Label',
        isActivityLabel: true,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
