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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgNpGckio6kzs6Mp3GARXhDWgFCcRPLek',
    appId: '1:133026118495:android:db7e9fb25b52ec7d1254ea',
    messagingSenderId: '133026118495',
    projectId: 'tugas-besar-7e24d',
    databaseURL: 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com',
    storageBucket: 'tugas-besar-7e24d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAICDMKnjhiLO_xToaamWsP8hnLacFqLb0',
    appId: '1:133026118495:ios:409258deb678bb171254ea',
    messagingSenderId: '133026118495',
    projectId: 'tugas-besar-7e24d',
    databaseURL: 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com',
    storageBucket: 'tugas-besar-7e24d.appspot.com',
    iosBundleId: 'com.example.tugasBesar',
  );
}
