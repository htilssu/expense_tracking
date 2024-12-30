import 'package:expense_tracking/presentation/features/greeting/screen/greeting_screen.dart';
import 'package:expense_tracking/presentation/features/greeting/widget/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GreetingScreen displays initial UI elements', (WidgetTester tester) async {
    // Build the GreetingScreen widget.
    await tester.pumpWidget(const MaterialApp(
      home: GreetingScreen(),
    ));

    // Verify that the initial UI elements are displayed.
    expect(find.text('Gain total control of your money'), findsOneWidget);
    expect(find.text('Become your own money manager and make every cent count'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(StepIndicator), findsOneWidget);
    expect(find.text('Đăng ký'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });

  testWidgets('GreetingScreen responds to swipe gestures', (WidgetTester tester) async {
    // Build the GreetingScreen widget.
    await tester.pumpWidget(const MaterialApp(
      home: GreetingScreen(),
    ));

    // Verify initial step is 1.
    final stepIndicator = tester.widget<StepIndicator>(find.byType(StepIndicator));
    expect(stepIndicator.currentStep, 1);

    // Swipe left to go to the previous step.
    await tester.fling(find.byType(StepIndicator), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(stepIndicator.currentStep, 1); // Should remain 1 as it's the first step.

    // Swipe right to go to the next step.
    await tester.fling(find.byType(StepIndicator), const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(stepIndicator.currentStep, 2); // Should move to the next step.
  });
}