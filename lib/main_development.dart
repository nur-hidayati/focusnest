import 'package:focusnest/firebase_options_dev.dart' as dev;
import 'package:focusnest/main_common.dart';

void main() async {
  await mainCommon(dev.DefaultFirebaseOptions.currentPlatform, 'DEVELOPMENT');
}
