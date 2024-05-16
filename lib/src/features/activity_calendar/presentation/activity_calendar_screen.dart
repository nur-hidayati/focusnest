import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/user_not_found.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/features/activity_calendar/data/activity_calendar_providers.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/add_activity_timer.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/custom_calendar.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/update_activity_timer.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
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
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                builder: (BuildContext context) {
                  return userId != null
                      ? AddActivityTimer(
                          userId: userId,
                          startDateTime: DateTime.now(),
                          duration: const Duration(minutes: 15),
                        )
                      : const UserNotFound();
                },
              );
            },
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
                                        return UpdateActivityTimer(
                                          timerId: activity.id,
                                          startDateTime: activity.startDateTime,
                                          label: activity.activityLabel,
                                          duration: Duration(
                                              seconds: activity
                                                  .actualDurationInSeconds),
                                        );
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
                                        title: formatDurationsToReadable(
                                            Duration(
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
