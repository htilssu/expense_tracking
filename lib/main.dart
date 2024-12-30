import 'package:expense_tracking/firebase_options.dart';
import 'package:expense_tracking/infrastructure/repository/user_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/app_theme.dart';
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

    return FutureBuilder(
      future: UserRepositoryImpl().findById(auth.currentUser?.uid ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(
                create: (context) {
                  if (snapshot.data != null) {
                    return UserBloc.fromState(UserLoaded(user: snapshot.data!));
                  } else {
                    return UserBloc();
                  }
                },
              ),
            ],
            child: Builder(
              builder: (context) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'TH',
                  theme: AppTheme.lightTheme(),
                  home: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoaded) {
                        return const HomeScreen();
                      } else {
                        return const LoginScreen();
                      }
                    },
                  ),
                );
              },
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          home: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
