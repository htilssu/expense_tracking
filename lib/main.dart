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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Khi đang chờ kết nối
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
                      "assets/images/pig_colorful.png",
                      width: MediaQuery.of(context).size.width,
                    ),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        }

        // Nếu không có người dùng đăng nhập (snapshot.hasData là false)
        if (!snapshot.hasData) {
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
              home: LoadingOverlay(
                const LoginScreen(),
              ),
            ),
          );
        }

        // Nếu có người dùng đăng nhập, lấy thông tin từ repository
        return FutureBuilder(
          future: UserRepositoryImpl().findById(snapshot.data!.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.done) {
              if (userSnapshot.hasData) {
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
                    home: LoadingOverlay(
                      const MainPageView(),
                    ),
                  ),
                );
              } else {
                // Trường hợp không tìm thấy user trong database
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
                    home: LoadingOverlay(
                      const LoginScreen(),
                    ),
                  ),
                );
              }
            }

            // Đang tải thông tin người dùng
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
      },
    );
  }
}
