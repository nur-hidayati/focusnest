import 'dart:io';

// Used in CI/CD pipelines to dynamically configure Firebase options based on the production environment
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
        apiKey: '${envVars['PROD_WEB_API_KEY']}',
        appId: '${envVars['PROD_WEB_APP_ID']}',
        messagingSenderId: '${envVars['PROD_FIREBASE_MESSAGING_SENDER_ID']}',
        projectId: '${envVars['PROD_FIREBASE_PROJECT_ID']}',
        authDomain: '${envVars['PROD_WEB_AUTH_DOMAIN']}',
        storageBucket: '${envVars['PROD_FIREBASE_STORAGE_BUCKET']}',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: '${envVars['PROD_ANDROID_API_KEY']}',
          appId: '${envVars['PROD_ANDROID_APP_ID']}',
          messagingSenderId: '${envVars['PROD_FIREBASE_MESSAGING_SENDER_ID']}',
          projectId: '${envVars['PROD_FIREBASE_PROJECT_ID']}',
          storageBucket: '${envVars['PROD_FIREBASE_STORAGE_BUCKET']}',
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: '${envVars['PROD_IOS_API_KEY']}',
          appId: '${envVars['PROD_IOS_APP_ID']}',
          messagingSenderId: '${envVars['PROD_FIREBASE_MESSAGING_SENDER_ID']}',
          projectId: '${envVars['PROD_FIREBASE_PROJECT_ID']}',
          storageBucket: '${envVars['PROD_FIREBASE_STORAGE_BUCKET']}',
          iosBundleId: '${envVars['PROD_IOS_BUNDLE_ID']}',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
''';

  File('lib/firebase_options_prod.dart').writeAsStringSync(firebaseOptions);
}
