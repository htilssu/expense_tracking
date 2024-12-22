import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            SvgPicture.asset(
              "assets/images/hold_money.svg",
              width: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Gain total control of your money",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Become your own money manager and make every cent count",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black45,
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: implement
              },
              style: ButtonStyle(),
              child: Text("Đăng ký"),
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: implement
              },
              style: ButtonStyle(),
              child: Text("Đăng nhập"),
            )
          ],
        ),
      ),
    );
  }
}
