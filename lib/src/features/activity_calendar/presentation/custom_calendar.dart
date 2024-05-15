import 'package:flutter/material.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/utils/date_time_helper.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelectedChanged;
  final CalendarFormat calendarFormat;

  const CustomCalendar({
    required this.selectedDate,
    required this.onDateSelectedChanged,
    required this.calendarFormat,
    super.key,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final DateTime _now = DateTime.now();
  late DateTime _focusedDay;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _focusedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            headerPadding: EdgeInsets.only(top: 0, bottom: 10),
          ),
          calendarFormat: widget.calendarFormat,
          calendarStyle: CalendarStyle(
            selectedDecoration:
                _dateHighlightedDecoration(AppColor.primaryColor),
            todayDecoration:
                _dateHighlightedDecoration(AppColor.secondaryColor),
          ),
          focusedDay: _focusedDay,
          firstDay: subtractDays(_now, 3652),
          lastDay: addDays(_now, 3652),
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDate, selectedDay)) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDay = focusedDay;
                widget.onDateSelectedChanged(_selectedDate);
              });
            }
          },
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onPageChanged: (focusedDay) {
            setState(() => _focusedDay = focusedDay);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomText(
            title: DateFormat('EEEE, d MMMM y').format(_selectedDate),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  BoxDecoration _dateHighlightedDecoration(Color color) {
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    );
  }
}
