import 'package:flutter/material.dart';
import 'package:focusnest/src/features/activity_timer/data/activity_timer_database.dart';

// class ActivityCalendarScreen extends StatelessWidget {
//   const ActivityCalendarScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Calendar'),
//       ),
//     );
//   }
// }

class ActivityCalendarScreen extends StatelessWidget {
  const ActivityCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = ActivityTimerDatabase().activityTimersDao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: StreamBuilder<List<ActivityTimer>>(
        stream: dao.watchAllActivityTimers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities found.'));
          }
          final activities = snapshot.data!;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                title: Text(activity.activityLabel),
                subtitle:
                    Text('Duration: ${activity.durationInSeconds} seconds\n'
                        'Start: ${activity.startDateTime}\n'
                        'End: ${activity.endDateTime}'),
              );
            },
          );
        },
      ),
    );
  }
}
