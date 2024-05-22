import 'dart:io';

// Used in CI/CD pipelines to dynamically configure Firebase options based on the staging environment
void main() {
  var envVars = Platform.environment;

  // Construct FirebaseOptions based on the platform
  var firebaseOptions = '''
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: '${envVars['STG_WEB_API_KEY']}',
        appId: '${envVars['STG_WEB_APP_ID']}',
        messagingSenderId: '${envVars['STG_FIREBASE_MESSAGING_SENDER_ID']}',
        projectId: '${envVars['STG_FIREBASE_PROJECT_ID']}',
        authDomain: '${envVars['STG_WEB_AUTH_DOMAIN']}',
        storageBucket: '${envVars['STG_FIREBASE_STORAGE_BUCKET']}',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: '${envVars['STG_ANDROID_API_KEY']}',
          appId: '${envVars['STG_ANDROID_APP_ID']}',
          messagingSenderId: '${envVars['STG_FIREBASE_MESSAGING_SENDER_ID']}',
          projectId: '${envVars['STG_FIREBASE_PROJECT_ID']}',
          storageBucket: '${envVars['STG_FIREBASE_STORAGE_BUCKET']}',
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: '${envVars['STG_IOS_API_KEY']}',
          appId: '${envVars['STG_IOS_APP_ID']}',
          messagingSenderId: '${envVars['STG_FIREBASE_MESSAGING_SENDER_ID']}',
          projectId: '${envVars['STG_FIREBASE_PROJECT_ID']}',
          storageBucket: '${envVars['STG_FIREBASE_STORAGE_BUCKET']}',
          iosBundleId: '${envVars['STG_IOS_BUNDLE_ID']}',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
''';

  File('lib/firebase_options_stg.dart').writeAsStringSync(firebaseOptions);
}
