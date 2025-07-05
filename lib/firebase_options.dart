import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDkFDY-zn2gTM1D81XdBbQC76KVjlLWDyw',
    appId: '1:933848500274:web:YOUR_WEB_APP_ID',
    messagingSenderId: '933848500274',
    projectId: 'blog-app-6149a',
    authDomain: 'blog-app-6149a.firebaseapp.com',
    storageBucket: 'blog-app-6149a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkFDY-zn2gTM1D81XdBbQC76KVjlLWDyw',
    appId: '1:933848500274:android:8c1466b6cfc3957452942b',
    messagingSenderId: '933848500274',
    projectId: 'blog-app-6149a',
    storageBucket: 'blog-app-6149a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkFDY-zn2gTM1D81XdBbQC76KVjlLWDyw',
    appId: '1:933848500274:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '933848500274',
    projectId: 'blog-app-6149a',
    storageBucket: 'blog-app-6149a.appspot.com',
    iosBundleId: 'com.adhyan.blog_app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkFDY-zn2gTM1D81XdBbQC76KVjlLWDyw',
    appId: '1:933848500274:ios:YOUR_MACOS_APP_ID',
    messagingSenderId: '933848500274',
    projectId: 'blog-app-6149a',
    storageBucket: 'blog-app-6149a.appspot.com',
    iosBundleId: 'com.adhyan.blog_app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDkFDY-zn2gTM1D81XdBbQC76KVjlLWDyw',
    appId: '1:933848500274:windows:YOUR_WINDOWS_APP_ID',
    messagingSenderId: '933848500274',
    projectId: 'blog-app-6149a',
    storageBucket: 'blog-app-6149a.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDkFDY-zn2gTM1D81XdBbQC76KVjlLWDyw',
    appId: '1:933848500274:linux:YOUR_LINUX_APP_ID',
    messagingSenderId: '933848500274',
    projectId: 'blog-app-6149a',
    storageBucket: 'blog-app-6149a.appspot.com',
  );
} 