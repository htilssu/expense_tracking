import 'package:expense_tracking/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/app_color.dart';
import 'presentation/bloc/user_bloc.dart';
import 'presentation/features/authenticate/screen/login_screen.dart';
import 'presentation/features/overview/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    Widget screen = auth.currentUser != null ? HomeScreen() : LoginScreen();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracking',
        theme: ThemeData(
          colorScheme: AppColor.lightTheme(),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(providers: [
          BlocProvider(create: (context) => UserBloc()),
        ], child: screen));
  }
}
