import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focusnest/src/common_widgets/custom_button.dart';
import 'package:focusnest/src/common_widgets/custom_text.dart';
import 'package:focusnest/src/constants/app_color.dart';
import 'package:focusnest/src/constants/app_padding.dart';
import 'package:focusnest/src/constants/routes_name.dart';
import 'package:focusnest/src/constants/spacers.dart';
import 'package:go_router/go_router.dart';

// Full screen that is displayed only when the timer completes naturally
// Does not show if the user manually stops the timer
class TimerDoneScreen extends StatefulWidget {
  final Duration duration;
  final bool playSound;

  const TimerDoneScreen({
    required this.duration,
    this.playSound = true,
    super.key,
  });

  @override
  State<TimerDoneScreen> createState() => _TimerDoneScreenState();
}

class _TimerDoneScreenState extends State<TimerDoneScreen> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (widget.playSound) {
      _playSound();
    }
    // Set the app to full-screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    // Restore the system UI to its normal state
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/timer-completion.m4a'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: Padding(
        padding: AppPadding.screenPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: AppColor.greenColor,
              ),
              Spacers.mediumVertical,
              const CustomText(
                title: 'Well Done!',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              Spacers.mediumVertical,
              const CustomText(
                title:
                    'You have successfully completed the activity. Keep up the great work and continue pushing forward!',
                textAlign: TextAlign.center,
              ),
              Spacers.largeVertical,
              CustomButton(
                title: 'Done',
                onPressed: () => context.goNamed(RoutesName.activityTimer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
