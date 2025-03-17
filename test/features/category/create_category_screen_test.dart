import 'package:bloc_test/bloc_test.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/repository/category_repository.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/features/category/create_category_screen.dart';
import 'package:expense_tracking/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_category_screen_test.mocks.dart';

// Tạo mock class cho CategoryRepository và Auth
@GenerateMocks([CategoryRepository, Auth])
void main() {
  late MockCategoryRepository mockCategoryRepository;
  late MockCategoryBloc mockCategoryBloc;
  late MockCategorySelectorCubit mockCategorySelectorCubit;
  late MockAuth mockAuth;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    mockCategoryBloc = MockCategoryBloc();
    mockCategorySelectorCubit = MockCategorySelectorCubit();
    mockAuth = MockAuth();

    // Mock CategoryBloc
    whenListen(
      mockCategoryBloc,
      Stream<CategoryState>.value(CategoryInitial()),
      initialState: CategoryInitial(),
    );

    // Mock CategorySelectorCubit
    whenListen(
      mockCategorySelectorCubit,
      Stream<CategorySelectorState>.value(IncomeCategory()),
      initialState: IncomeCategory(),
    );

    // Mock Auth.uid
    when(mockAuth.uid).thenReturn('mocked_user_id');
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>.value(value: mockCategoryBloc),
        BlocProvider<CategorySelectorCubit>.value(value: mockCategorySelectorCubit),
      ],
      child: MaterialApp(
        home: CreateCategoryScreen(categoryRepository: mockCategoryRepository),
      ),
    );
  }

  group('CreateCategoryScreen Widget Tests', () {
    testWidgets('Hiển thị đúng giao diện', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Danh mục mới'), findsOneWidget);
      expect(find.text('Tên danh mục'), findsOneWidget);
      expect(find.text('Ngân sách (Budget)'), findsOneWidget);
      expect(find.text('Tạo danh mục'), findsOneWidget);
    });

    testWidgets('Nhập tên danh mục hợp lệ', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Mua sắm');
      await tester.pump();

      expect(find.text('Mua sắm'), findsOneWidget);
    });

    testWidgets('Nhập tên danh mục bị trùng', (tester) async {
      whenListen(
        mockCategoryBloc,
        Stream<CategoryState>.value(CategoryLoaded([
          Category('Du lịch', 0, 500000, 'expense', 'mocked_user_id', icon: 'travel_icon'),
        ])),
        initialState: CategoryLoaded([
          Category('Du lịch', 0, 500000, 'expense', 'mocked_user_id', icon: 'travel_icon'),
        ]),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Du lịch');
      await tester.pump();

      expect(find.text('Tên danh mục đã tồn tại'), findsOneWidget);
    });

    testWidgets('Nhập ngân sách hợp lệ', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '5000');
      await tester.pump();

      expect(find.text('5000'), findsOneWidget);
    });

    testWidgets('Hiển thị lỗi khi nhập ngân sách không hợp lệ', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, '-5000'); // Nhập số âm
      await tester.pump();

      expect(find.text('Ngân sách phải là số dương'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'abc'); // Nhập ký tự không phải số
      await tester.pump();

      expect(find.text('Ngân sách phải là số hợp lệ'), findsOneWidget);
    });
    testWidgets('Hiển thị lỗi khi chưa nhập tên danh mục', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tạo danh mục'));
      await tester.pump();

      expect(find.text('Vui lòng nhập tên danh mục'), findsOneWidget);
    });

    testWidgets('Hiển thị lỗi khi chưa nhập ngân sách', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Giải trí'); // Nhập tên danh mục
      await tester.pump();

      await tester.tap(find.text('Tạo danh mục'));
      await tester.pump();

      expect(find.text('Vui lòng nhập ngân sách'), findsOneWidget);
    });

    testWidgets('Tạo danh mục thành công', (tester) async {
      when(mockCategoryRepository.save(any)).thenAnswer((_) async =>
          Category('Du lịch', 0, 500000, 'expense', 'mocked_user_id', icon: 'travel_icon'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Du lịch');
      await tester.enterText(find.byType(TextField).last, '500000');
      await tester.pump();

      await tester.tap(find.text('Tạo danh mục'));
      await tester.pumpAndSettle();

      verify(mockCategoryRepository.save(any)).called(1);
    });
  });
}

// Mock class cho CategoryBloc
class MockCategoryBloc extends MockBloc<CategoryEvent, CategoryState>
    implements CategoryBloc {}

// Mock class cho CategorySelectorCubit
class MockCategorySelectorCubit extends MockCubit<CategorySelectorState>
    implements CategorySelectorCubit {}
class MockAuth extends Mock implements Auth {
  @override
  String get uid => super.noSuchMethod(Invocation.getter(#uid), returnValue: 'mocked_user_id');
}