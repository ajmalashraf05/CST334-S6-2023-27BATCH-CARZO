// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {

    if (kIsWeb) {
      throw UnsupportedError(
        'Web not configured',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS not configured',
        );

      default:
        throw UnsupportedError(
          'Platform not supported',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSySampleAndroidKey123456',
    appId: '1:1234567890:android:abc123def456',
    messagingSenderId: '1234567890',
    projectId: 'carzo-dealer',
    storageBucket: 'carzo-dealer.appspot.com',
    databaseURL: 'https://carzo-dealer-default-rtdb.firebaseio.com',
  );
  );
}