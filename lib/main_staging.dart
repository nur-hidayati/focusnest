import 'package:focusnest/firebase_options_stg.dart' as stg;
import 'package:focusnest/main_common.dart';

void main() async {
  await mainCommon(stg.DefaultFirebaseOptions.currentPlatform, 'STAGING');
}
