import 'package:expense_tracking/application/dto/email_password_register.dart';
import 'package:expense_tracking/application/service/category_service_impl.dart';
import 'package:expense_tracking/application/service/email_password_register_service.dart';
import 'package:expense_tracking/exceptions/email_exist_exception.dart';
import 'package:expense_tracking/infrastructure/repository/user_repository_impl.dart';
import 'package:expense_tracking/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/text_constant.dart';
import '../../../../domain/entity/user.dart' as entity;
import '../../../bloc/user/user_bloc.dart';
import '../../../common_widgets/et_button.dart';
import '../../../common_widgets/et_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isShowPassword = false;
  String errorMessage = '';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.center,
          child: Text('Đăng ký'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                children: [
                  EtTextField(
                    validator: emailValidator,
                    controller: emailController,
                    suffixIcon: const Icon(Icons.email_rounded),
                    label: 'Email',
                  ),
                  EtTextField(
                    validator: passwordValidator,
                    obscureText: !isShowPassword,
                    controller: passwordController,
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
                  EtTextField(
                    validator: confirmPasswordValidator,
                    obscureText: !isShowPassword,
                    controller: confirmPasswordController,
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
                    label: 'Nhập lại mật khẩu',
                  ),
                  if (errorMessage.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Column(
                    children: [
                      EtButton(
                        onPressed: isLoading ? null : _handleRegister,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Đăng ký',
                                style: TextStyle(
                                  fontSize: TextSize.medium,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Đã có tài khoản? Đăng nhập ngay'))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    setState(() {
      errorMessage = '';
      isLoading = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await onEmailPasswordRegister();
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      BlocProvider.of<UserBloc>(context).add(LoadUserEvent(result));
      Navigator.pop(context); // Quay lại LoginScreen
    }
  }

  Future<String?> onEmailPasswordRegister() async {
    try {
      await EmailPasswordRegisterService().register(
          EmailPasswordRegister(emailController.text, passwordController.text));

      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await UserRepositoryImpl()
            .save(entity.User(user.uid, user.email!,0, '', ''));

        await CategoryServiceImpl().saveDefaultCategories();

        return user.uid;
      }
    } on EmailExistException {
      setState(() {
        errorMessage = 'Email đã tồn tại, vui lòng chọn email khác';
      });
    }

    return null;
  }

  String? emailValidator(String? text) {
    if (!Validator.isValidEmail(text!)) {
      return 'Email không đúng định dạng';
    }
    return null;
  }

  String? passwordValidator(String? text) {
    if (passwordController.text.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    if (!Validator.isValidPassword(text!)) {
      return 'Mật khẩu phải có ít nhất 1 chữ hoa, 1 số, 1 ký tự đặc biệt';
    }
    return null;
  }

  String? confirmPasswordValidator(String? text) {
    if (passwordController.text != text) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }
}
