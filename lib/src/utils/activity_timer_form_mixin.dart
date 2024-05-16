import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin ActivityTimerFormMixin<T extends StatefulWidget> on State<T> {
  late TextEditingController _activityLabelController;
  TextEditingController get activityLabelController => _activityLabelController;

  late DateTime _selectedStartDateTime;
  DateTime get selectedStartDateTime => _selectedStartDateTime;

  DateTime? _tempSelectedStartDateTime;
  DateTime? get tempSelectedStartDateTime => _tempSelectedStartDateTime;

  late Duration _selectedDuration;
  Duration get selectedDuration => _selectedDuration;

  Duration? _tempSelectedDuration;
  Duration? get tempSelectedDuration => _tempSelectedDuration;

  @override
  void dispose() {
    super.dispose();
    _activityLabelController.dispose();
  }

  void initActivityTimerForm(
      String label, DateTime startDateTime, Duration duration) {
    _activityLabelController = TextEditingController(text: label);
    _selectedStartDateTime = startDateTime;
    _selectedDuration = duration;
  }

  void handleOnStartDateTimeChanged(DateTime newDate) {
    _tempSelectedStartDateTime = newDate;
  }

  void handleOnStartDateTimeConfirmed() {
    if (_tempSelectedStartDateTime != null) {
      setState(() {
        _selectedStartDateTime = _tempSelectedStartDateTime!;
      });
      context.pop();
    }
  }

  void handleOnDurationChanged(Duration newDuration) {
    _tempSelectedDuration = newDuration;
  }

  void handleOnDurationConfirmed() {
    if (_tempSelectedDuration != null) {
      setState(() {
        _selectedDuration = _tempSelectedDuration!;
      });
      context.pop();
    }
  }
}
