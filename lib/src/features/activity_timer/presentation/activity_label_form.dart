import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_header.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/application/timer_service.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:go_router/go_router.dart';

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

    activityLabelController =
        TextEditingController(text: ref.read(activityLabelProvider));
  }

  @override
  void dispose() {
    activityLabelController.dispose();
    super.dispose();
  }

  void _handleOnDoneActivityLabelUpdate() {
    if (activityLabelController.text.isNotEmpty) {
      ref
          .read(activityLabelProvider.notifier)
          .updateActivityLabel(activityLabelController.text);
      context.pop();
    } else {
      showOKAlert(
        context: context,
        title: 'Invalid Activity Label',
        content: 'Activity Label cannot be empty',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          BottomSheetHeader(
            title: 'Activity Label',
            onDone: () => _handleOnDoneActivityLabelUpdate(),
            onCancel: () => context.pop(),
          ),
          Padding(
            padding: AppPadding.screenPadding,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: activityLabelController,
                  hintText: 'Activity Label',
                  maxLength: 40,
                ),
              ],
            ),
          ),
          Spacers.extraLargeVertical,
        ],
      ),
    );
  }
}
