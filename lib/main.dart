import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stock_management/Environment/environment.dart';
import 'package:stock_management/splash_screen.dart';

import 'Database/storage_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //changes environment as per needed for building apk
  const String environmentUrl = String.fromEnvironment(
    "ENVIRONMENT",
    defaultValue: EnvironmentUrl.DEVELOPMENT,
  );

  EnvironmentUrl().initConfig(environmentUrl);

  //Initialize Firebase on com.example.stock_management
  await Firebase.initializeApp();
  //Initialize and create instance of login user and stored data
  await StorageUtil.getInstance();

  //Create FirebaseCrashlytics for testing error of com.example.stock_management
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Intouch_stock',
      builder: EasyLoading.init(),
      theme: ThemeData(
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(
            Colors.red,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black, size: 24),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.only(right: 30, left: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            padding: const EdgeInsets.only(right: 30, left: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const NewSplashScreen(),
    );
  }
}
