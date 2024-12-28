import 'package:expense_tracking/exceptions/user_notfound_exception.dart';
import 'package:expense_tracking/exceptions/wrong_password_exception.dart';
import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../application/dto/email_password_login.dart';
import '../../../../application/service/email_password_login_service.dart';
import '../../../../constants/text_constant.dart';
import '../../../common_widgets/et_button.dart';
import '../../../common_widgets/et_textfield.dart';
import '../../overview/screen/home_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.center,
          child: Text("Đăng nhập"),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsetsDirectional.only(top: 100),
        child: Column(
          spacing: 16,
          children: [
            EtTextField(
              controller: emailController,
              suffixIcon: Icon(Icons.email_rounded),
              label: "Tên đăng nhập",
            ),
            EtTextField(
              controller: passwordController,
              obscureText: !isShowPassword,
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
            if (errorMessage.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            EtButton(
              onPressed: () {
                onEmailPasswordLogin();
              },
              child: Text(
                "Đăng nhập",
                style: TextStyle(
                    fontSize: TextSize.medium,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Bạn không có tài khoản?"),
                TextButton(
                    style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                    child: Text(
                      "Đăng ký",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Hoặc"),
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
                    "assets/images/google.svg",
                    height: 26,
                    width: 26,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
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
                    "assets/images/facebook.svg",
                    height: 32,
                    width: 32,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isShowPassword = false;
  }

  void onEmailPasswordLogin() async {
    try {
      await EmailPasswordLoginService(EmailPasswordLogin(
              email: emailController.text, password: passwordController.text))
          .login();

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ));
      }
    } on UserNotFoundException {
      setState(() {
        errorMessage = "Người dùng không tồn tại";
      });
    } on WrongPasswordException {
      setState(() {
        errorMessage = "Mật khẩu không đúng";
      });
    } on Exception {
      setState(() {
        errorMessage = "Đã có lỗi xảy ra, vui lòng thử lại sau";
      });
    }
  }
}
