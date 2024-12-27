import 'package:flutter/material.dart';

import '../../../../constants/text_constant.dart';
import '../../../../domain/service/login_service.dart';
import '../../../common_widgets/et_button.dart';
import '../../../common_widgets/et_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

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
              suffixIcon: Icon(Icons.email_rounded),
              label: "Email",
            ),
            EtTextField(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(
                  !true ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              label: "Mật khẩu",
            ),
            EtTextField(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {});
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
                  onPressed: () {},
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
}
