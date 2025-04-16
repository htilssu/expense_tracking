import 'package:expense_tracking/firebase_options.dart';
import 'package:expense_tracking/main.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/common_widgets/number_input.dart';
import 'package:expense_tracking/presentation/features/category/create_category_screen.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/category_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  });

  setUp(() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'toandong2004@gmail.com',
        password: '07102004aA@',
      );
    } catch (e) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: 'toandong2004@gmail.com',
        password: '07102004aA@',
      );
    }
  });

  group('CreateCategoryScreen Integration Tests', () {
    Future<Widget> buildTestWidget() async {
      return const MyApp();
    }

    // Hàm trợ giúp để đăng nhập
    Future<void> loginIfNeeded(WidgetTester tester) async {
      final emailTextField = find.byWidgetPredicate(
          (widget) => widget is EtTextField && widget.label == 'Tên đăng nhập');

      if (emailTextField.evaluate().isNotEmpty) {
        final passwordTextField = find.byWidgetPredicate(
            (widget) => widget is EtTextField && widget.label == 'Mật khẩu');

        await tester.enterText(emailTextField, 'toandong2004@gmail.com');
        await tester.enterText(passwordTextField, '07102004aA@');

        final loginButton = find.byWidgetPredicate((widget) =>
            widget is EtButton &&
            (widget.child is Text &&
                (widget.child as Text).data == 'Đăng nhập'));
        await tester.tap(loginButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }
    }

    // Hàm trợ giúp để mở màn hình tạo danh mục
    Future<void> navigateToCreateCategoryScreen(WidgetTester tester) async {
      await tester.tap(
        find.descendant(
          of: find.byType(FloatingActionButton),
          matching: find.byIcon(Icons.add),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CategorySelector).first);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithIcon(IconButton, Icons.add).first);
      await tester.pumpAndSettle();
    }

    testWidgets('should display CreateCategoryScreen correctly',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await loginIfNeeded(tester);
        await navigateToCreateCategoryScreen(tester);

        // Kiểm tra tiêu đề màn hình
        expect(find.text('Danh mục mới'), findsOneWidget);

        // Kiểm tra các trường nhập liệu có hiển thị đúng
        expect(find.byType(EtTextField), findsOneWidget);
        expect(find.byType(NumberInput), findsOneWidget);
        expect(find.text('Tên danh mục'), findsOneWidget);
        expect(find.text('Ngân sách (Budget)'), findsOneWidget);

        // Kiểm tra nút tạo danh mục
        final createButton = find.widgetWithText(EtButton, 'Tạo danh mục');
        expect(createButton, findsOneWidget);

        // Kiểm tra nút tạo danh mục bị vô hiệu hóa ban đầu (vì chưa nhập tên)
        final buttonWidget = tester.widget<EtButton>(createButton);
        expect(buttonWidget.onPressed, isNull);
      });
    });

    testWidgets(
        'should enable create button when valid category name is entered',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await loginIfNeeded(tester);
        await navigateToCreateCategoryScreen(tester);

        // Nút bị vô hiệu hóa ban đầu
        final createButtonBefore =
            find.widgetWithText(EtButton, 'Tạo danh mục');
        final buttonWidgetBefore = tester.widget<EtButton>(createButtonBefore);
        expect(buttonWidgetBefore.onPressed, isNull);

        // Nhập tên danh mục
        final categoryNameField = find.byType(EtTextField).first;
        await tester.enterText(categoryNameField, 'Danh mục test');
        await tester.pumpAndSettle();

        // Kiểm tra nút được kích hoạt
        final createButtonAfter = find.widgetWithText(EtButton, 'Tạo danh mục');
        final buttonWidgetAfter = tester.widget<EtButton>(createButtonAfter);
        expect(buttonWidgetAfter.onPressed, isNotNull);
      });
    });

    testWidgets(
        'should create category successfully when valid data is entered',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await loginIfNeeded(tester);
        await navigateToCreateCategoryScreen(tester);

        // Tìm EtTextField cho tên danh mục
        final categoryNameField = find.byType(EtTextField).first;
        final budgetField = find.byType(NumberInput).first;

        // Nhập dữ liệu hợp lệ
        final uniqueName = 'Mua sắm ${DateTime.now().millisecondsSinceEpoch}';
        await tester.enterText(categoryNameField, uniqueName);
        await tester.enterText(budgetField, '500000');
        await tester.pumpAndSettle();

        // Nhấn nút tạo danh mục
        final createButton = find.byWidgetPredicate((widget) =>
            widget is EtButton &&
            (widget.child is Text &&
                (widget.child as Text).data == 'Tạo danh mục'));

        await tester.tap(createButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Kiểm tra đã thoát khỏi màn hình tạo danh mục
        expect(find.text('Tên danh mục đã tồn tại'), findsNothing);
        expect(find.byType(CreateCategoryScreen), findsNothing);
      });
    });

    testWidgets('should show error when category name is empty',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await loginIfNeeded(tester);
        await navigateToCreateCategoryScreen(tester);

        // Chỉ nhập budget, để trống tên
        final budgetField = find.byType(NumberInput).first;
        await tester.enterText(budgetField, '100000');
        await tester.pumpAndSettle();

        // Kiểm tra nút tạo danh mục vẫn bị vô hiệu hóa
        final createButton = find.widgetWithText(EtButton, 'Tạo danh mục');
        final buttonWidget = tester.widget<EtButton>(createButton);
        expect(buttonWidget.onPressed, isNull);

        // Thử nhập tên rồi xóa để kích hoạt validator
        final categoryNameField = find.byType(EtTextField).first;
        await tester.enterText(categoryNameField, 'test');
        await tester.pumpAndSettle();
        await tester.enterText(categoryNameField, '');
        await tester.pumpAndSettle();

        // Kiểm tra thông báo lỗi validator
        expect(find.text('Tên danh mục không được để trống'), findsOneWidget);
      });
    });

    testWidgets('should create category when budget is empty (optional field)',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await loginIfNeeded(tester);
        await navigateToCreateCategoryScreen(tester);

        // Nhập tên danh mục mới, để trống budget
        final categoryNameField = find.byType(EtTextField).first;
        final uniqueName =
            'Không budget ${DateTime.now().millisecondsSinceEpoch}';
        await tester.enterText(categoryNameField, uniqueName);
        await tester.pumpAndSettle();

        // Kiểm tra nút đã được kích hoạt
        final createButton = find.widgetWithText(EtButton, 'Tạo danh mục');
        final buttonWidget = tester.widget<EtButton>(createButton);
        expect(buttonWidget.onPressed, isNotNull);

        await tester.tap(createButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Kiểm tra đã thoát khỏi màn hình tạo danh mục
        expect(find.text('Tên danh mục đã tồn tại'), findsNothing);
        expect(find.byType(CreateCategoryScreen), findsNothing);
      });
    });

    testWidgets('should show error when category name already exists',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await loginIfNeeded(tester);

        // Tạo danh mục đầu tiên với tên duy nhất
        final duplicateName =
            'Trùng tên ${DateTime.now().millisecondsSinceEpoch}';

        await navigateToCreateCategoryScreen(tester);
        final categoryNameField = find.byType(EtTextField).first;
        await tester.enterText(categoryNameField, duplicateName);
        await tester.pumpAndSettle();

        final createButton = find.byWidgetPredicate((widget) =>
            widget is EtButton &&
            (widget.child is Text &&
                (widget.child as Text).data == 'Tạo danh mục'));

        await tester.tap(createButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Tạo lại danh mục với tên trùng
        await navigateToCreateCategoryScreen(tester);
        final categoryNameField2 = find.byType(EtTextField).first;
        await tester.enterText(categoryNameField2, duplicateName);
        await tester.pumpAndSettle();

        // Kiểm tra hiển thị lỗi tên trùng
        expect(find.text('Tên danh mục đã tồn tại'), findsOneWidget);

        // Kiểm tra nút tạo danh mục bị vô hiệu hóa
        final createButton2 = find.widgetWithText(EtButton, 'Tạo danh mục');
        final buttonWidget = tester.widget<EtButton>(createButton2);
        expect(buttonWidget.onPressed, isNull);
      });
    });

    testWidgets('should toggle category type between expense and income',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await loginIfNeeded(tester);

        // Mở màn hình danh mục
        await tester.tap(
          find.descendant(
            of: find.byType(FloatingActionButton),
            matching: find.byIcon(Icons.add),
          ),
        );
        await tester.pumpAndSettle();

        // Mặc định là expense, chuyển sang income
        final categorySelector = find.byType(CategorySelector);
        expect(categorySelector, findsOneWidget);

        // Tìm tab Income và nhấn vào
        final incomeTab = find.descendant(
          of: categorySelector,
          matching: find.text('Thu nhập'),
        );

        if (incomeTab.evaluate().isNotEmpty) {
          await tester.tap(incomeTab);
          await tester.pumpAndSettle();
        }

        // Mở tạo danh mục
        await tester.tap(find.widgetWithIcon(IconButton, Icons.add).first);
        await tester.pumpAndSettle();

        // Nhập tên danh mục thu nhập
        final categoryNameField = find.byType(EtTextField).first;
        await tester.enterText(categoryNameField, 'Thu nhập mới');
        await tester.pumpAndSettle();

        // Nhấn tạo và kiểm tra đã tạo thành công
        final createButton = find.widgetWithText(EtButton, 'Tạo danh mục');
        await tester.tap(createButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.byType(CreateCategoryScreen), findsNothing);
      });
    });
  });
}

class CategorySelectorCubit extends Cubit<String> {
  CategorySelectorCubit() : super('expense');
  void selectExpense() => emit('expense');
  void selectIncome() => emit('income');
}
