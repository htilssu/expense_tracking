import 'package:expense_tracking/constants/text_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/logging.dart';
import '../../../common_widgets/et_button.dart' show EtButton;
import '../../authenticate/screen/login_screen.dart';
import '../widget/step_indicator.dart';

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  late int step;
  late int totalStep;

  void nextStep() {
    if (step + 1 > totalStep) return;
    setState(() {
      step++;
    });
  }

  void previousStep() {
    setState(() {
      if (step - 1 < 0) {
        return;
      }
      step--;
    });
  }

  @override
  void initState() {
    super.initState();
    step = 1;
    totalStep = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              SvgPicture.asset(
                'assets/images/hold_money.svg',
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Gain total control of your money',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Become your own money manager and make every cent count',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                    decoration: TextDecoration.none),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  Logger.info(details);
                  if (details.velocity.pixelsPerSecond.dx < 0) {
                    previousStep();
                  } else if (details.velocity.pixelsPerSecond.dx > 0) {
                    nextStep();
                  }
                },
                child: StepIndicator(step, totalStep),
              ),
              const SizedBox(
                height: 16,
              ),
              EtButton(
                onPressed: () {},
                child: Text(
                  'Đăng ký',
                  style: TextStyle(
                      fontSize: TextSize.medium,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              EtButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ));
                  },
                  color: const Color(0x61339DEF),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: TextSize.medium,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
