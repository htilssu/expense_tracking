import 'package:expense_tracking/firebase_options.dart';
import 'package:expense_tracking/infrastructure/repository/user_repository_impl.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:expense_tracking/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracking/presentation/features/loading_overlay.dart';
import 'package:expense_tracking/presentation/features/main_page_view.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracking/domain/entity/user.dart' as entity;

import 'constants/app_theme.dart';
import 'presentation/bloc/user/user_bloc.dart';
import 'presentation/features/authenticate/screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<entity.User?>? _future;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          _future = null;
        }

        if (snapshot.data != null) {
          _future ??= UserRepositoryImpl().findById(snapshot.data!.uid);

          return FutureBuilder(
            future: _future,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.done) {
                if (userSnapshot.hasData) {
                  if (kDebugMode) {
                    Logger.info('LogIn successfully: ${userSnapshot.data}');
                  }
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<UserBloc>(
                        create: (context) => UserBloc.fromState(
                            UserLoaded(user: userSnapshot.data!)),
                      ),
                      BlocProvider<CategoryBloc>(
                        create: (context) => CategoryBloc()
                          ..add(LoadCategories(userSnapshot.data!)),
                      ),
                      BlocProvider<LoadingCubit>(
                        create: (context) => LoadingCubit(),
                      ),
                      BlocProvider<TransactionBloc>(
                        create: (context) => TransactionBloc(
                            TransactionInitial(userSnapshot.data!)),
                      ),
                    ],
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Trezo',
                      theme: AppTheme.lightTheme(),
                      home: const LoadingOverlay(
                        MainPageView(),
                      ),
                    ),
                  );
                } else {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<UserBloc>(
                        create: (context) => UserBloc(),
                      ),
                      BlocProvider<LoadingCubit>(
                        create: (context) => LoadingCubit(),
                      ),
                    ],
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Trezo',
                      theme: AppTheme.lightTheme(),
                      home: const LoadingOverlay(
                        LoginScreen(),
                      ),
                    ),
                  );
                }
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 100),
                    child: const CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/pig_colorful.png',
                      width: MediaQuery.of(context).size.width,
                    ),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider<UserBloc>(
              create: (context) => UserBloc(),
            ),
            BlocProvider<LoadingCubit>(
              create: (context) => LoadingCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Trezo',
            theme: AppTheme.lightTheme(),
            home: const LoadingOverlay(
              LoginScreen(),
            ),
          ),
        );
      },
    );
  }
}
