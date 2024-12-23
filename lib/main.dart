import 'package:expense_tracking/features/greeting/screen/greeting_screen.dart';
import 'package:expense_tracking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/app_color.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracking',
      theme: ThemeData(
        colorScheme: AppColor.lightTheme(),
        useMaterial3: true,
      ),
      home: GreetingScreen(),
    );
  }
}
