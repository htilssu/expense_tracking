import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/firebase_options.dart';
import 'package:expense_tracking/infrastructure/repository/category_repository_impl.dart';
import 'package:expense_tracking/main.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/features/category/create_category_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

    testWidgets('should display CreateCategoryScreen correctly', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget() );
        await tester.pumpAndSettle();
        // Nhập email hợp lệ
        await tester.enterText(find.byType(TextField).at(0), 'toandong2004@gmail.com');
        // Nhập mật khẩu hợp lệ
        await tester.enterText(find.byType(TextField).at(1), '07102004aA@');

        // Nhấn nút "Đăng nhập"
        await tester.tap(find.widgetWithText(ElevatedButton, 'Đăng nhập'));
        await tester.pumpAndSettle(); // Wait for Firebase
      });
    });

    testWidgets('should create category successfully when valid data is entered', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('categoryNameField')), 'Mua sắm');
        await tester.enterText(find.byKey(const Key('budgetField')), '500000');

        await tester.tap(find.widgetWithText(ElevatedButton, 'Tạo danh mục'));
        await tester.pumpAndSettle();

        expect(find.text('Tên danh mục đã tồn tại'), findsNothing);
        expect(find.byType(CreateCategoryScreen), findsNothing); // Assuming navigation occurs
      });
    });

    testWidgets('should show error when category name is empty', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('budgetField')), '100000');

        await tester.tap(find.widgetWithText(ElevatedButton, 'Tạo danh mục'), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.text('Tên danh mục không được để trống'), findsOneWidget);
      });
    });

    testWidgets('should show error when category name already exists', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final categoryRepository = CategoryRepositoryImpl();
        final currentUser = FirebaseAuth.instance.currentUser!;
        await categoryRepository.save(Category('Mua sắm', 0, 500000, 'expense', currentUser.uid));

        await tester.pumpWidget(await buildTestWidget());
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('categoryNameField')), 'Mua sắm');
        await tester.enterText(find.byKey(const Key('budgetField')), '500000');

        await tester.tap(find.widgetWithText(ElevatedButton, 'Tạo danh mục'), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.text('Tên danh mục đã tồn tại'), findsOneWidget);
        expect(find.byType(CreateCategoryScreen), findsOneWidget);
      });
    });
  });
}

class CategorySelectorCubit extends Cubit<String> {
  CategorySelectorCubit() : super('expense');
  void selectExpense() => emit('expense');
  void selectIncome() => emit('income');
}