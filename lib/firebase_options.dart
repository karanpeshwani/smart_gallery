// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyDAZwNydRvu6QBwKUAaWc219xUXG42kgPM',
    appId: '1:907286769133:web:7e09c84a2102d4cfab8be4',
    messagingSenderId: '907286769133',
    projectId: 'smart-gallery-firebase',
    authDomain: 'smart-gallery-firebase.firebaseapp.com',
    storageBucket: 'smart-gallery-firebase.appspot.com',
    measurementId: 'G-1N31HK5HFL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrF9_lLi6zWiiqmxanpsx3mNhBMYrgaDo',
    appId: '1:907286769133:android:e6ab2df0b07fb357ab8be4',
    messagingSenderId: '907286769133',
    projectId: 'smart-gallery-firebase',
    storageBucket: 'smart-gallery-firebase.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPpTe-W7Aj9yHI_-75Qbgx3iVaRF-RFFU',
    appId: '1:907286769133:ios:78b0982570ef33b2ab8be4',
    messagingSenderId: '907286769133',
    projectId: 'smart-gallery-firebase',
    storageBucket: 'smart-gallery-firebase.appspot.com',
    iosClientId: '907286769133-m8cajfritv553h0ieal2sg98gc48g37q.apps.googleusercontent.com',
    iosBundleId: 'com.example.smartGalleryFlutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAPpTe-W7Aj9yHI_-75Qbgx3iVaRF-RFFU',
    appId: '1:907286769133:ios:78b0982570ef33b2ab8be4',
    messagingSenderId: '907286769133',
    projectId: 'smart-gallery-firebase',
    storageBucket: 'smart-gallery-firebase.appspot.com',
    iosClientId: '907286769133-m8cajfritv553h0ieal2sg98gc48g37q.apps.googleusercontent.com',
    iosBundleId: 'com.example.smartGalleryFlutterApp',
  );
}
