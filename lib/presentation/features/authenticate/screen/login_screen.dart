import 'package:expense_tracking/exceptions/user_notfound_exception.dart';
import 'package:expense_tracking/exceptions/wrong_password_exception.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../application/dto/email_password_login.dart';
import '../../../../application/service/email_password_login_service.dart';
import '../../../../constants/text_constant.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../common_widgets/et_button.dart';
import '../../../common_widgets/et_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isShowPassword;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  EtTextField(
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Tên đăng nhập không được để trống';
                      }
                      return null;
                    },
                    controller: emailController,
                    suffixIcon: const Icon(Icons.email_rounded),
                    label: 'Tên đăng nhập',
                  ),
                  EtTextField(
                    validator: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Mật khẩu không được để trống';
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: !isShowPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      icon: Icon(
                        !isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    label: 'Mật khẩu',
                  ),
                  if (errorMessage.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.start,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  EtButton(
                    onPressed: () {
                      setState(() {
                        errorMessage = '';
                      });
                      if (!_formKey.currentState!.validate()) return;
                      onEmailPasswordLogin().then(
                        (value) {
                          if (context.mounted) {
                            BlocProvider.of<UserBloc>(context).add(LoadUser(
                                FirebaseAuth.instance.currentUser!.uid));
                          }
                        },
                      ).onError(
                        (error, stackTrace) {
                          Logger.error(error);
                        },
                      );
                    },
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                          fontSize: TextSize.medium,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bạn không có tài khoản?',
                        ),
                        TextButton(
                            style: const ButtonStyle(
                                minimumSize: WidgetStatePropertyAll(Size.zero),
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(horizontal: 3))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ));
                            },
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Hoặc'),
                      ),
                      Expanded(child: Divider())
                    ],
                  ),
                  EtButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/google.svg',
                          height: 26,
                          width: 26,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Đăng nhập bằng Google',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  ),
                  EtButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/facebook.svg',
                          height: 32,
                          width: 32,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Đăng nhập bằng Facebook',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isShowPassword = false;
  }

  Future<void> onEmailPasswordLogin() async {
    try {
      await EmailPasswordLoginService().login(EmailPasswordLogin(
          email: emailController.text, password: passwordController.text));

      return;
    } on UserNotFoundException {
      setState(() {
        errorMessage = 'Người dùng không tồn tại';
      });
    } on WrongPasswordException {
      setState(() {
        errorMessage = 'Mật khẩu không đúng';
      });
    } on Exception {
      setState(() {
        errorMessage = 'Đã có lỗi xảy ra, vui lòng thử lại sau';
      });
    }

    throw Exception(errorMessage);
  }
}
