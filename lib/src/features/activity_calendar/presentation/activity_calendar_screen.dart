import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/common_widgets/loading_indicator.dart';
import 'package:focusnest/src/common_widgets/loading_manager.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:focusnest/src/constants/strings.dart';
import 'package:focusnest/src/features/activity_calendar/data/activity_calendar_dao.dart';
import 'package:focusnest/src/features/activity_calendar/data/activity_calendar_providers.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/add_activity_timer.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/custom_calendar.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/update_activity_timer.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_screen_controller.dart';
import 'package:focusnest/src/utils/alert_dialogs.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:table_calendar/table_calendar.dart';

// Screen for Activity Calendar where it displayed Calendar using TableCalendar package.
// The items is displayed if the start date same as selected date in calendar
// Items displayed is Activity label, timer duration, start time and end time
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

  void _showAddActivityTimerModal(String userId) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return AddActivityTimer(
          userId: userId,
          startDateTime: DateTime.now(),
          duration: const Duration(minutes: 15),
        );
      },
    );
  }

  void _showUpdateActivityTimerModal(ActivityTimer activity) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return UpdateActivityTimer(
          userId: activity.userId,
          timerId: activity.id,
          startDateTime: activity.startDateTime,
          label: activity.activityLabel,
          duration: Duration(seconds: activity.actualDurationInSeconds),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final authState = ref.watch(authScreenControllerProvider);
    final userId = authRepository.currentUser?.uid ?? Strings.tempUser;
    final dao = ref.watch(activityCalendarDaoProvider);

    return LoadingManager(
      isLoading: authState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar'),
          centerTitle: true,
          actions: _buildCalendarAppBarActions(userId),
        ),
        body: _buildCalendarContent(userId, dao),
      ),
    );
  }

  List<Widget> _buildCalendarAppBarActions(String userId) {
    return [
      IconButton(
        icon: Icon(
          _calendarFormat == CalendarFormat.month
              ? Icons.calendar_view_week
              : Icons.calendar_month,
        ),
        onPressed: _toggleCalendarFormat,
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => _showAddActivityTimerModal(userId),
      ),
    ];
  }

  Widget _buildCalendarContent(String userId, ActivityCalendarDao dao) {
    return Column(
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
                return const Center(child: LoadingIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No activities found.'));
              }
              return _buildActivityList(snapshot.data!, userId);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityList(List<ActivityTimer> activities, String userId) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: activities.length,
      itemBuilder: (context, index) {
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
                  bool? isDeleteConfirm = await showDeleteRecordAlert(context);
                  if (isDeleteConfirm == true) {
                    await ActivityTimerDatabase()
                        .activityCalendarDao
                        .deleteActivityTimerById(activity.id, userId);
                  }
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                label: 'Delete',
              ),
            ],
          ),
          child: _buildActivityTile(activity),
        );
      },
    );
  }

  Widget _buildActivityTile(ActivityTimer activity) {
    return Column(
      children: [
        const Divider(height: 1),
        GestureDetector(
          onTap: () => _showUpdateActivityTimerModal(activity),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: CustomText(
                title: '${activity.activityLabel} - ${activity.userId}',
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: CustomText(
                title: formatDurationsToReadable(
                    Duration(seconds: activity.actualDurationInSeconds)),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    title: formatTime(activity.startDateTime),
                    fontSize: 14,
                    color: AppColor.greyColor,
                  ),
                  Spacers.extraSmallVertical,
                  CustomText(
                    title: formatTime(activity.endDateTime),
                    fontSize: 14,
                    color: AppColor.greyColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
