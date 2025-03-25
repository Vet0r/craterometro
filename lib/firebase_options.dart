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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCGRYOPxM9VavMe9n6Z-xNo2K-LMTx_GNU',
    appId: '1:966944467345:web:e1ee23ff86a7b7a4a9d230',
    messagingSenderId: '966944467345',
    projectId: 'craterometro',
    authDomain: 'craterometro.firebaseapp.com',
    storageBucket: 'craterometro.firebasestorage.app',
    measurementId: 'G-HBBDJG2B54',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4rkk_OM4Ywc8HAEWC7e1wH12y0LgczjY',
    appId: '1:966944467345:android:d62ca11b537d1222a9d230',
    messagingSenderId: '966944467345',
    projectId: 'craterometro',
    storageBucket: 'craterometro.firebasestorage.app',
  );
}
