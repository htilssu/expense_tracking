import 'package:expense_tracking/firebase_options.dart';
import 'package:expense_tracking/infrastructure/repository/user_repository_impl.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:expense_tracking/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:expense_tracking/presentation/features/loading_overlay.dart';
import 'package:expense_tracking/presentation/features/main_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final _userFuture = UserRepositoryImpl()
      .findById(FirebaseAuth.instance.currentUser?.uid ?? '');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userFuture,
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
              BlocProvider<CategoryBloc>(
                create: (context) {
                  return CategoryBloc()..add(LoadCategories(snapshot.data!));
                },
              ),
              BlocProvider(
                create: (context) => LoadingCubit(),
              ),
              BlocProvider(
                create: (context) =>
                    TransactionBloc(TransactionInitial(snapshot.data!)),
              )
            ],
            child: Builder(
              builder: (context) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Trezo',
                    theme: AppTheme.lightTheme(),
                    home: LoadingOverlay(
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoaded) {
                            return MainPageView();
                          } else {
                            return const LoginScreen();
                          }
                        },
                      ),
                    ));
              },
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          home: Scaffold(
            body: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/pig_colorful.png",
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
