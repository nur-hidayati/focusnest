import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusnest/src/common_widgets/user_not_found.dart';
import 'package:focusnest/src/features/activity_calendar/presentation/custom_calendar.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_providers.dart';
import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
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

  void _handleOnDateSelectionChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userId = authRepository.currentUser?.uid;
    final dao = ref.watch(activityTimersDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: userId != null
          ? Column(
              children: [
                CustomCalendar(
                  selectedDate: _selectedDate,
                  onDateSelectedChanged: _handleOnDateSelectionChanged,
                  calendarFormat: CalendarFormat.week,
                ),
                Expanded(
                  child: StreamBuilder<List<ActivityTimer>>(
                    stream: dao.watchAllActivityTimers(userId),
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
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return ListTile(
                            title: Text(activity.activityLabel),
                            subtitle: Text(
                                'Duration: ${activity.actualDurationInSeconds} seconds\n'
                                'Start: ${activity.startDateTime}\n'
                                'End: ${activity.endDateTime}\n'
                                'userId: ${activity.userId}'),
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
