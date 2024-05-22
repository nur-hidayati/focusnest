import 'package:focusnest/firebase_options_prod.dart' as prod;
import 'package:focusnest/main_common.dart';

// Main entry point for the Production flavor
void main() async {
  await mainCommon(prod.DefaultFirebaseOptions.currentPlatform, 'PRODUCTION');
}
