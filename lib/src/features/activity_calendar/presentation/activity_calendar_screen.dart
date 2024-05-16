import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusnest/src/common_widgets/bottom_sheet_contents.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/custom_text_form_field.dart';
import 'package:focusnest/src/common_widgets/link_text_button.dart';
import 'package:focusnest/src/common_widgets/selection_input_card.dart';
import 'package:focusnest/src/common_widgets/user_not_found.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_calendar/data/activity_calendar_providers.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/custom_calendar.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:focusnest/src/utils/modal_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityCalendarScreen extends ConsumerStatefulWidget {
  const ActivityCalendarScreen({super.key});

  @override
  ConsumerState<ActivityCalendarScreen> createState() =>
      _ActivityCalendarScreenState();
}

class _ActivityCalendarScreenState
    extends ConsumerState<ActivityCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  void _toggleCalendarFormat() {
    setState(() {
      _calendarFormat = _calendarFormat == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week;
    });
  }

  void _handleOnDateSelectionChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userId = authRepository.currentUser?.uid;
    final dao = ref.watch(activityCalendarDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: Icon(
              _calendarFormat == CalendarFormat.month
                  ? Icons.calendar_view_week
                  : Icons.calendar_month,
            ),
            onPressed: _toggleCalendarFormat,
          ),
        ],
      ),
      body: userId != null
          ? Column(
              children: [
                CustomCalendar(
                  selectedDate: _selectedDate,
                  onDateSelectedChanged: _handleOnDateSelectionChanged,
                  calendarFormat: _calendarFormat,
                ),
                Expanded(
                  child: StreamBuilder<List<ActivityTimer>>(
                    stream: dao.watchActivitiesForDate(userId, _selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No activities found.'));
                      }
                      final activities = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final dao =
                              ActivityTimerDatabase().activityCalendarDao;
                          final activity = activities[index];
                          return Slidable(
                            key: ValueKey(activity.id),
                            closeOnScroll: true,
                            endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    bool? isDeleteConfirm = await showAlertDialog(
                                        context: context,
                                        title: 'Delete Record',
                                        content:
                                            'Are you sure want to delete this record permanently? You cannot undo this action.');
                                    if (isDeleteConfirm == true) {
                                      await dao.deleteActivityTimerById(
                                          activity.id, userId);
                                    }
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Divider(height: 1),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      useRootNavigator: true,
                                      builder: (BuildContext context) {
                                        return const UpdateActivityTimer();
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      title: CustomText(
                                        title: activity.activityLabel,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      subtitle: CustomText(
                                        title: formatSecondsToReadable(Duration(
                                            seconds: activity
                                                .actualDurationInSeconds)),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            title: formatTime(
                                                activity.startDateTime),
                                            fontSize: 14,
                                            color: AppColor.greyColor,
                                          ),
                                          Spacers.extraSmallVertical,
                                          CustomText(
                                            title: formatTime(
                                                activity.endDateTime),
                                            fontSize: 14,
                                            color: AppColor.greyColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )
          : const UserNotFound(),
    );
  }
}

class UpdateActivityTimer extends StatefulWidget {
  const UpdateActivityTimer({super.key});

  @override
  State<UpdateActivityTimer> createState() => _UpdateActivityTimerState();
}

class _UpdateActivityTimerState extends State<UpdateActivityTimer> {
  final activityLabelController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BottomSheetContents(
      headerTitle: 'Edit Record',
      onDoneActivityLabelUpdate: () {},
      child: Column(
        children: [
          CustomTextFormField(
            controller: activityLabelController,
            hintText: 'Activity Label',
          ),
          Spacers.smallVertical,
          SelectionInputCard(
            label: 'Start from',
            hintText: 'Please select',
            onPressed: () {
              datePickerModal(
                context: context,
                onDateTimeChanged: (p0) {},
                mode: CupertinoDatePickerMode.dateAndTime,
                dateSelectionMode: DateSelectionMode.past,
                onDone: () {},
                onCancel: () {},
              );
            },
          ),
          Spacers.smallVertical,
          SelectionInputCard(
            label: 'End at',
            hintText: 'Please select',
            onPressed: () {
              datePickerModal(
                context: context,
                onDateTimeChanged: (p0) {},
                mode: CupertinoDatePickerMode.dateAndTime,
                dateSelectionMode: DateSelectionMode.past,
                onDone: () {},
                onCancel: () {},
              );
            },
          ),
          Spacers.smallVertical,
          SelectionInputCard(
            label: 'Duration',
            hintText: 'Please select',
            onPressed: () {
              durationPickerModal(
                context: context,
                currentDuration: const Duration(minutes: 5),
                onTimerDurationChanged: (Duration picked) {},
                onCancel: () => context.pop(),
                onDone: () {},
              );
            },
          ),
          Spacers.smallVertical,
          LinkTextButton(
            title: 'Delete',
            color: AppColor.warningColor,
            onPressed: () {},
          ),
          Spacers.largeVertical,
        ],
      ),
    );
  }
}
