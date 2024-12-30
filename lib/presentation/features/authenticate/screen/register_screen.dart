import 'package:expense_tracking/application/dto/email_password_login.dart';
import 'package:expense_tracking/application/dto/email_password_register.dart';
import 'package:expense_tracking/application/service/email_password_login_service.dart';
import 'package:expense_tracking/application/service/email_password_register_service.dart';
import 'package:expense_tracking/exceptions/email_exist_exception.dart';
import 'package:expense_tracking/infrastructure/repository/user_repository_impl.dart';
import 'package:expense_tracking/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../constants/text_constant.dart';
import '../../../../domain/entity/user.dart' as entity;
import '../../../common_widgets/et_button.dart';
import '../../../common_widgets/et_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isShowPassword = false;
  String errorMessage = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.center,
          child: Text("Đăng ký"),
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
                    suffixIcon: Icon(Icons.email_rounded),
                    label: "Email",
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
                    label: "Mật khẩu",
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
                    label: "Nhập lại mật khẩu",
                  ),
                  if (errorMessage.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  Column(
                    children: [
                      EtButton(
                        onPressed: () {
                          setState(() {
                            errorMessage = "";
                          });
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          onEmailPasswordLogin();
                        },
                        child: Text(
                          "Đăng ký",
                          style: TextStyle(
                              fontSize: TextSize.medium,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Text("Đã có tài khoản? Đăng nhập ngay"))
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

  Future<void> onEmailPasswordLogin() async {
    try {
      await EmailPasswordRegisterService(EmailPasswordRegister(
              emailController.text, passwordController.text))
          .register();

      await EmailPasswordLoginService(EmailPasswordLogin(
              email: emailController.text, password: passwordController.text))
          .login();

      var user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        UserRepositoryImpl()
            .save(entity.User(user.uid, "", user.email!, "", ""));
      }
    } on EmailExistException {
      setState(() {
        errorMessage = "Email đã tồn tại, vui lòng chọn email khác";
      });
    }
  }

  String? emailValidator(String? text) {
    if (!Validator.isValidEmail(text!)) {
      return "Email không đúng định dạng";
    }
    return null;
  }

  String? passwordValidator(String? text) {
    if (passwordController.text.length < 6) {
      return "Mật khẩu phải có ít nhất 6 ký tự";
    }
    if (!Validator.isValidPassword(text!)) {
      return "Mật khẩu phải có ít nhất 1 chữ hoa, 1 số, 1 ký tự đặc biệt";
    }
    return null;
  }

  String? confirmPasswordValidator(String? text) {
    if (passwordController.text != text) {
      return "Mật khẩu không khớp";
    }
    return null;
  }
}
