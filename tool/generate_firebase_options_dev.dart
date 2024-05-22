import 'dart:io';

// Used in CI/CD pipelines to dynamically configure Firebase options based on the development environment

void main() {
  var envVars = Platform.environment;

  var firebaseOptions = '''
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: '${envVars['DEV_WEB_API_KEY']}',
        appId: '${envVars['DEV_WEB_APP_ID']}',
        messagingSenderId: '${envVars['DEV_FIREBASE_MESSAGING_SENDER_ID']}',
        projectId: '${envVars['DEV_FIREBASE_PROJECT_ID']}',
        authDomain: '${envVars['DEV_WEB_AUTH_DOMAIN']}',
        storageBucket: '${envVars['DEV_FIREBASE_STORAGE_BUCKET']}',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: '${envVars['DEV_ANDROID_API_KEY']}',
          appId: '${envVars['DEV_ANDROID_APP_ID']}',
          messagingSenderId: '${envVars['DEV_FIREBASE_MESSAGING_SENDER_ID']}',
          projectId: '${envVars['DEV_FIREBASE_PROJECT_ID']}',
          storageBucket: '${envVars['DEV_FIREBASE_STORAGE_BUCKET']}',
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: '${envVars['DEV_IOS_API_KEY']}',
          appId: '${envVars['DEV_IOS_APP_ID']}',
          messagingSenderId: '${envVars['DEV_FIREBASE_MESSAGING_SENDER_ID']}',
          projectId: '${envVars['DEV_FIREBASE_PROJECT_ID']}',
          storageBucket: '${envVars['DEV_FIREBASE_STORAGE_BUCKET']}',
          iosBundleId: '${envVars['DEV_IOS_BUNDLE_ID']}',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
''';

  File('lib/firebase_options_dev.dart').writeAsStringSync(firebaseOptions);
}
