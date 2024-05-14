import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_header.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/duration_picker.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_timer/application/timer_service.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:go_router/go_router.dart';

class TimerSection extends ConsumerStatefulWidget {
  const TimerSection({
    super.key,
  });

  @override
  ConsumerState<TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends ConsumerState<TimerSection> {
  final _activityLabelController = TextEditingController();
  Duration _duration = const Duration(minutes: 15);
  Duration? _tempDuration;

  @override
  void dispose() {
    _activityLabelController.dispose();
    super.dispose();
  }

  void _showDurationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext builder) {
        return DurationPicker(
          duration: _duration,
          onCancel: () => context.pop(),
          onDone: _handleOnDoneDurationPicker,
          onTimerDurationChanged: _handleOnTimerDurationChanged,
        );
      },
    );
  }

  void _handleOnTimerDurationChanged(Duration picked) {
    _tempDuration = picked;
  }

  void _handleOnDoneDurationPicker() {
    if (_tempDuration != null) {
      if (_tempDuration!.inMinutes == 0) {
        showOKAlert(
          context: context,
          title: 'Invalid Duration',
          content: 'Duration cannot be zero',
        );
      } else {
        setState(() {
          _duration = _tempDuration!;
          _tempDuration = null;
          ref
              .read(timerDurationProvider.notifier)
              .updateTimerDuration(formatDurationToHms(_duration));
          context.pop();
        });
      }
    } else {
      context.pop();
    }
  }

  void _showUpdateLabel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateModal) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetHeader(
                  title: 'Activity Label',
                  onDone: () {
                    if (_activityLabelController.text.isNotEmpty) {
                      setStateModal(() {
                        ref
                            .read(activityLabelProvider.notifier)
                            .updateActivityLabel(_activityLabelController.text);
                        context.pop();
                      });
                      setState(() {});
                    } else {
                      showOKAlert(
                        context: context,
                        title: 'Invalid Activity Label',
                        content: 'Activity Label cannot be empty',
                      );
                    }
                  },
                  onCancel: () {
                    _activityLabelController.clear();
                    context.pop();
                  },
                ),
                Padding(
                  padding: AppPadding.screenPadding,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _activityLabelController,
                        hintText: 'Activity Label',
                        maxLength: 40,
                      ),
                    ],
                  ),
                ),
                Spacers.extraLargeVertical
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityLabel = ref.watch(activityLabelProvider);
    final timerDuration = ref.watch(timerDurationProvider);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => _showUpdateLabel(context),
                child: CustomText(
                  title: activityLabel,
                  textType: TextType.titleLarge,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
            Spacers.extraSmallHorizontal,
            const Icon(Icons.navigate_next)
          ],
        ),
        Spacers.smallVertical,
        GestureDetector(
          onTap: () => _showDurationPicker(context),
          child: CustomText(
            title: timerDuration,
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: AppColor.greyColor,
          ),
        ),
        Spacers.smallVertical,
        CustomButton(
          title: 'Start Focus',
          onPressed: () => context.pushNamed(
            RoutesName.timerStart,
            queryParameters: {
              'duration': _duration.inSeconds.toString(),
              'label': activityLabel,
            },
          ),
        ),
      ],
    );
  }
}
