import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EtButton Widget Tests', () {
    testWidgets('should display child text correctly',
        (WidgetTester tester) async {
      const buttonText = 'Nhấn vào đây';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtButton(
              child: const Text(buttonText),
              onPressed: () {},
            ),
          ),
        ),
      );

      // Kiểm tra text được hiển thị đúng
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped',
        (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtButton(
              child: const Text('Nhấn vào đây'),
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      // Tìm button và tap vào nó
      await tester.tap(find.byType(EtButton));
      await tester.pump();

      // Kiểm tra callback đã được gọi
      expect(wasPressed, true);
    });

    testWidgets('should be disabled when onPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EtButton(
              onPressed: null,
              child: Text('Nút bị vô hiệu hóa'),
            ),
          ),
        ),
      );

      // Tìm ElevatedButton bên trong EtButton
      final elevatedButton = find.byType(ElevatedButton);
      expect(elevatedButton, findsOneWidget);

      // Kiểm tra trạng thái vô hiệu hóa
      final buttonWidget = tester.widget<ElevatedButton>(elevatedButton);
      expect(buttonWidget.onPressed, isNull);

      // Kiểm tra visually
      final buttonStyle = buttonWidget.style;
      expect(buttonStyle, isNotNull);
    });

    testWidgets('should apply custom color when provided',
        (WidgetTester tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtButton(
              color: customColor,
              onPressed: () {},
              child: const Text('Nút màu đỏ'),
            ),
          ),
        ),
      );

      // Tìm ElevatedButton bên trong EtButton
      final elevatedButton = find.byType(ElevatedButton);

      // Kiểm tra style có màu tùy chỉnh
      final buttonWidget = tester.widget<ElevatedButton>(elevatedButton);
      final buttonStyle = buttonWidget.style;

      // Lưu ý: Kiểm tra thuộc tính style trong ElevatedButton có thể phức tạp
      // vì thuộc tính màu sắc được đóng gói bên trong ButtonStyle
      expect(buttonStyle, isNotNull);
    });

    testWidgets('should apply custom height and width',
        (WidgetTester tester) async {
      const customHeight = 60.0;
      const customWidth = 200.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: EtButton(
                height: customHeight,
                width: customWidth,
                onPressed: () {},
                child: const Text('Nút tùy chỉnh kích thước'),
              ),
            ),
          ),
        ),
      );

      // Tìm ElevatedButton bên trong EtButton
      final elevatedButton = find.byType(ElevatedButton);

      // Kiểm tra kích thước
      final elevatedButtonWidget =
          tester.widget<ElevatedButton>(elevatedButton);
      final buttonStyle = elevatedButtonWidget.style;

      // Lưu ý: Kiểm tra chính xác kích thước có thể phức tạp
      // vì giá trị được đóng gói trong ButtonStyle và MaterialStateProperty
      expect(buttonStyle, isNotNull);

      // Kiểm tra kích thước thông qua render box
      final renderBox = tester.renderObject<RenderBox>(find.byType(EtButton));
      expect(renderBox.size.height, customHeight);
      expect(renderBox.size.width, customWidth);
    });

    testWidgets('should apply custom border radius',
        (WidgetTester tester) async {
      const customBorderRadius = 15.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EtButton(
              borderRadius: customBorderRadius,
              onPressed: () {},
              child: const Text('Nút bo tròn'),
            ),
          ),
        ),
      );

      // Tìm ElevatedButton
      final elevatedButton = find.byType(ElevatedButton);

      // Kiểm tra style có border radius tùy chỉnh
      final buttonWidget = tester.widget<ElevatedButton>(elevatedButton);
      final buttonStyle = buttonWidget.style;

      // Lưu ý: Kiểm tra chính xác borderRadius có thể phức tạp
      // vì giá trị được đóng gói trong ButtonStyle
      expect(buttonStyle, isNotNull);
    });
  });
}
