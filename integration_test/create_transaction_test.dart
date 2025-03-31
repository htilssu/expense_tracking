import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/firebase_options.dart';
import 'package:expense_tracking/infrastructure/repository/category_repository_impl.dart';
import 'package:expense_tracking/main.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/common_widgets/number_input.dart';
import 'package:expense_tracking/presentation/features/category/create_category_screen.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/create_transaction_screen.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/amount_input.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/category_selector.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/note_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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


    testWidgets('should create transaction successfully when valid data is entered', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        // Nhấn nút thêm giao dịch
        await tester.tap(
          find.descendant(
            of: find.byType(FloatingActionButton),
            matching: find.byIcon(Icons.add),
          ),
        );
        await tester.pumpAndSettle();

        // Nhập số tiền
        await tester.enterText(find.descendant
          (of:find.byType(AmountInput),
            matching: find.byType(TextField)), '500000');

        await tester.pumpAndSettle();

        // Chọn danh mục
        await tester.tap(find.byType(CategorySelector).first);
        await tester.pumpAndSettle();

        // Chọn danh mục "Mua sắm"
        await tester.tap(find.descendant(
          of: find.byType(GestureDetector),
          matching: find.text('Lương'),
        ).first);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton,'Xong'));
        await tester.pumpAndSettle();
        // Nhập ghi chú
        await tester.enterText(find.byType(NoteInput), 'Mua sắm hàng tháng');
        await tester.pumpAndSettle();

        // Nhấn nút Lưu
        await tester.tap(find.widgetWithText(EtButton, 'Lưu'));
        await tester.pumpAndSettle();

        // Kiểm tra giao dịch đã được tạo thành công
        expect(find.byType(CreateTransactionScreen), findsNothing);
      });
    });

      testWidgets('should show error when amount is zero', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        // Nhấn nút thêm giao dịch
        await tester.tap(
          find.descendant(
            of: find.byType(FloatingActionButton),
            matching: find.byIcon(Icons.add),
          ),
        );
        await tester.pumpAndSettle();

        // Nhập số tiền
        await tester.enterText(find.descendant
          (of:find.byType(AmountInput),
            matching: find.byType(TextField)), '0');

        await tester.pumpAndSettle();

        // Chọn danh mục
        await tester.tap(find.byType(CategorySelector).first);
        await tester.pumpAndSettle();

        // Chọn danh mục "Mua sắm"
        await tester.tap(find.descendant(
          of: find.byType(GestureDetector),
          matching: find.text('Lương'),
        ).first);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton,'Xong'));
        await tester.pumpAndSettle();
        // Nhập ghi chú
        await tester.enterText(find.byType(NoteInput), 'Mua sắm hàng tháng');
        await tester.pumpAndSettle();

        // Nhấn nút Lưu
        await tester.tap(find.widgetWithText(EtButton, 'Lưu'));
        await tester.pumpAndSettle();

        // Kiểm tra giao dịch đã được tạo thành công
        expect(find.byType(CreateTransactionScreen), findsOneWidget);
      });
    });


    testWidgets('should show error when category is not selected', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();
        // Nhấn nút thêm giao dịch
        await tester.tap(
          find.descendant(
            of: find.byType(FloatingActionButton),
            matching: find.byIcon(Icons.add),
          ),
        );
        await tester.pumpAndSettle();

        // Nhập số tiền
        await tester.enterText(find.descendant
          (of:find.byType(AmountInput),
            matching: find.byType(TextField)), '50000');
        await tester.pumpAndSettle();
        // Nhập ghi chú
        await tester.enterText(find.byType(NoteInput), 'Mua sắm hàng tháng');
        await tester.pumpAndSettle();

        // Nhấn nút Lưu
        await tester.tap(find.widgetWithText(EtButton, 'Lưu'));
        await tester.pumpAndSettle();

        // Kiểm tra giao dịch đã được tạo thành công
        expect(find.byType(CreateTransactionScreen), findsOneWidget);
      });
    });

    testWidgets('should show error when note is empty', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();
        // Nhấn nút thêm giao dịch
        await tester.tap(
          find.descendant(
            of: find.byType(FloatingActionButton),
            matching: find.byIcon(Icons.add),
          ),
        );
        await tester.pumpAndSettle();

        // Nhập số tiền
        await tester.enterText(find.descendant
          (of:find.byType(AmountInput),
            matching: find.byType(TextField)), '50000');
        await tester.pumpAndSettle();
        // Chọn danh mục
        await tester.tap(find.byType(CategorySelector).first);
        await tester.pumpAndSettle();

        // Chọn danh mục "Mua sắm"
        await tester.tap(find.descendant(
          of: find.byType(GestureDetector),
          matching: find.text('Lương'),
        ).first);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton,'Xong'));
        await tester.pumpAndSettle();
        // Nhấn nút Lưu
        await tester.tap(find.widgetWithText(EtButton, 'Lưu'));
        await tester.pumpAndSettle();

        // Kiểm tra giao dịch đã được tạo thành công
        expect(find.byType(CreateTransactionScreen), findsNothing);
      });
    });

  });
}
class CategorySelectorCubit extends Cubit<String> {
  CategorySelectorCubit() : super('expense');
  void selectExpense() => emit('expense');
  void selectIncome() => emit('income');
}