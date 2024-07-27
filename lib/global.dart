import 'package:ai_sign_language_recognition/common/services/storage_service.dart';
import 'package:ai_sign_language_recognition/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Global {
  static late StorageService storageService;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

  /*   await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
 */
    storageService = await StorageService().init();
  }
}
