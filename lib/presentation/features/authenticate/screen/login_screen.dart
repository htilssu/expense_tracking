import 'package:expense_tracking/presentation/features/authenticate/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/text_constant.dart';
import '../../../common_widgets/et_button.dart';
import '../../../common_widgets/et_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isShowPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.center,
          child: Text("Đăng nhập"),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsetsDirectional.only(top: 200),
        child: Column(
          spacing: 16,
          children: [
            EtTextField(
              suffixIcon: Icon(Icons.email_rounded),
              label: "Tên đăng nhập",
            ),
            EtTextField(
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
            EtButton(
              onPressed: () {},
              child: Text(
                "Đăng nhập",
                style: TextStyle(
                    fontSize: TextSize.medium,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary),
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
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => RegisterScreen(),));
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
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onPrimary),
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
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onPrimary),
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
}
