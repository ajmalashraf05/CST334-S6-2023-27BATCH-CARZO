import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "sample-web-key",
    appId: "1:123:web:abc",
    messagingSenderId: "123",
    projectId: "carzo-admin",
    storageBucket: "carzo-admin.appspot.com",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "sample-android-key",
    appId: "1:123:android:abc",
    messagingSenderId: "123",
    projectId: "carzo-admin",
    storageBucket: "carzo-admin.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "sample-ios-key",
    appId: "1:123:ios:abc",
    messagingSenderId: "123",
    projectId: "carzo-admin",
    storageBucket: "carzo-admin.appspot.com",
    iosBundleId: "com.example.carzoAdmin",
  );
}