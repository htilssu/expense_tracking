import 'package:expense_tracking/application/dto/email_password_register.dart';
import 'package:expense_tracking/application/service/email_password_register_service.dart';
import 'package:expense_tracking/exceptions/email_exist_exception.dart';
import 'package:expense_tracking/utils/validator.dart';
import 'package:flutter/material.dart';

import '../../../../constants/text_constant.dart';
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
  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.center,
          child: Text("Đăng ký"),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsetsDirectional.only(top: 200),
        child: Column(
          spacing: 16,
          children: [
            EtTextField(
              errorMessage: emailError,
              controller: emailController,
              suffixIcon: Icon(Icons.email_rounded),
              label: "Email",
            ),
            EtTextField(
              obscureText: isShowPassword,
              errorMessage: passwordError,
              controller: passwordController,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
                icon: Icon(
                  !isShowPassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              label: "Mật khẩu",
            ),
            EtTextField(
              obscureText: isShowPassword,
              errorMessage: confirmPasswordError,
              controller: confirmPasswordController,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
                icon: Icon(
                  !true ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              label: "Nhập lại mật khẩu",
            ),
            Column(
              children: [
                EtButton(
                  onPressed: () {
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
    );
  }

  Future<void> onEmailPasswordLogin() async {
    if (!isValidate()) {
      return;
    }

    try {
      await EmailPasswordRegisterService(EmailPasswordRegister(
              emailController.text, passwordController.text))
          .register();
    } on EmailExistException {
      setState(() {
        emailError = "Email đã tồn tại";
      });
    }
  }

  bool isValidate() {
    var isValid = true;

    setState(() {
      emailError = "";
      passwordError = "";
      confirmPasswordError = "";
    });

    if (emailController.text.isEmpty ||
        !Validator.isValidEmail(emailController.text)) {
      setState(() {
        emailError = "Email không đúng định dạng";
      });
      isValid = false;
    }
    if (passwordController.text.isEmpty ||
        !Validator.isValidPassword(passwordController.text)) {
      setState(() {
        passwordError =
            "Mật khẩu phải có ít nhất 6 ký tự, 1 chữ hoa, 1 số, 1 ký tự đặc biệt";
      });
      isValid = false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        confirmPasswordError = "Mật khẩu không khớp";
      });
      isValid = false;
    }
    return isValid;
  }
}
