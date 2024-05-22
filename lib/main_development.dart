import 'package:focusnest/firebase_options_dev.dart' as dev;
import 'package:focusnest/main_common.dart';

// Main entry point for the Development flavor
void main() async {
  await mainCommon(dev.DefaultFirebaseOptions.currentPlatform, 'DEVELOPMENT');
}
