import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/features/category/create_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });

  group(
    'Create Category Screen Test',
        () {
      testWidgets('Test widget not missing', (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: BlocProvider(
              create: (_) => CategorySelectorCubit(),
              child: CreateCategoryScreen(),
            ),
          ),
        );

        // Kiểm tra sự tồn tại của các widget quan trọng
        expect(find.text('Danh mục mới'), findsOneWidget);
        expect(find.byType(EtTextField), findsNWidgets(2));
        expect(
          find.descendant(
              of: find.byType(EtButton), matching: find.text('Tạo danh mục')),
          findsOneWidget,
        );
      });

      testWidgets('Press create category button with empty name expect error',
              (widgetTester) async {
            await widgetTester.pumpWidget(
              MaterialApp(
                home: BlocProvider(
                  create: (_) => CategorySelectorCubit(),
                  child: CreateCategoryScreen(),
                ),
              ),
            );

            await widgetTester.tap(find.descendant(
              of: find.byType(EtButton),
              matching: find.text('Tạo danh mục'),
            ));
            await widgetTester.pump();

            // Kiểm tra thông báo lỗi khi tên danh mục trống
            expect(find.text('Tên danh mục không được để trống'), findsOneWidget);
          });

      testWidgets('Enter category name and budget then press create',
              (widgetTester) async {
            await widgetTester.pumpWidget(
              MaterialApp(
                home: BlocProvider(
                  create: (_) => CategorySelectorCubit(),
                  child: CreateCategoryScreen(),
                ),
              ),
            );

            await widgetTester.enterText(
                find.byType(EtTextField).first, 'Ăn uống');
            await widgetTester.enterText(
                find.byType(EtTextField).last, '500000');

            await widgetTester.tap(find.descendant(
              of: find.byType(EtButton),
              matching: find.text('Tạo danh mục'),
            ));
            await widgetTester.pump();

            // Kiểm tra xem màn hình xử lý khi tạo danh mục hợp lệ
            expect(find.text('Ăn uống'), findsOneWidget);
            expect(find.text('500000'), findsOneWidget);
          });
    },
  );
}
