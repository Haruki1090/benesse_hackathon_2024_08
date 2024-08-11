// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAsEvrRj4pk8j9UiisrI20vrEeYvz8iEL0',
    appId: '1:101760414342:web:903fbed2a0500052df9707',
    messagingSenderId: '101760414342',
    projectId: 'benesse-hackathon-2024-08',
    authDomain: 'benesse-hackathon-2024-08.firebaseapp.com',
    storageBucket: 'benesse-hackathon-2024-08.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDRZKZm0JMB12wjpV3UxODScA4gLNNmdg',
    appId: '1:101760414342:android:f95c3f5fceb6f063df9707',
    messagingSenderId: '101760414342',
    projectId: 'benesse-hackathon-2024-08',
    storageBucket: 'benesse-hackathon-2024-08.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8Y4YT-E9WLdCNYFFnZk7Lcp5hm6R374k',
    appId: '1:101760414342:ios:0437875724aac44bdf9707',
    messagingSenderId: '101760414342',
    projectId: 'benesse-hackathon-2024-08',
    storageBucket: 'benesse-hackathon-2024-08.appspot.com',
    iosBundleId: 'com.example.benesseHackathon202408',
  );
}
