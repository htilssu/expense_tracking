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
            SizedBox(
              height: 150,
            ),
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
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Theme.of(context).colorScheme.primary;
                      }
                      return Theme.of(context).colorScheme.onPrimary;
                    },
                  ),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(45))),
              child: Text("Đăng ký"),
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: implement
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Theme.of(context).colorScheme.secondary;
                      }
                      return Theme.of(context).colorScheme.primary;
                    },
                  ),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(45))),
              child: Text(
                "Đăng nhập",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
