import 'package:expense_tracking/domain/repository/category_repository.dart';
import 'package:expense_tracking/infrastructure/repository/category_repository_impl.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/features/category/create_category_screen.dart';
import 'package:expense_tracking/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<CategoryRepositoryImpl>(),
  MockSpec<CategorySelectorCubit>(),
  MockSpec<CategoryBloc>(),
])
import 'create_category_screen_test.mocks.dart';

void main() {
  late CategoryRepository categoryRepository;
  late MockCategorySelectorCubit mockCubit;
  late MockCategoryBloc mockCategoryBloc;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Provide dummy values for Mockito
    provideDummy<CategoryState>(CategoryInitial());
    provideDummy<CategorySelectorState>(IncomeCategory());

    categoryRepository = MockCategoryRepositoryImpl();
    mockCubit = MockCategorySelectorCubit();
    mockCategoryBloc = MockCategoryBloc();

    // Stub required methods/properties
    when(mockCategoryBloc.stream).thenAnswer(
      (_) => Stream<CategoryState>.fromIterable([CategoryInitial()]),
    );

    // Stub the state getter if needed
    when(mockCategoryBloc.state).thenReturn(CategoryInitial());

    // Stub the cubit if needed
    when(mockCubit.state).thenReturn(IncomeCategory());
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<CategorySelectorState>.fromIterable([IncomeCategory()]),
    );
  });

  group(
    'Create Category Screen Test',
    () {
      testWidgets('Test widget not missing', (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider<CategorySelectorCubit>(
                  create: (_) => CategorySelectorCubit(),
                ),
                BlocProvider<CategoryBloc>(
                  create: (_) => mockCategoryBloc,
                ),
              ],
              child: CreateCategoryScreen(
                categoryRepository: categoryRepository,
              ),
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


      testWidgets('Enter category name and budget then press create',
          (widgetTester) async {
        Auth.uidFunction = () => 'test_uid';
        await widgetTester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider<CategorySelectorCubit>(
                  create: (_) => CategorySelectorCubit(),
                ),
                BlocProvider<CategoryBloc>(
                  create: (_) => mockCategoryBloc,
                ),
              ],
              child: CreateCategoryScreen(
                categoryRepository: categoryRepository,
              ),
            ),
          ),
        );

        await widgetTester.enterText(find.byType(EtTextField).first, 'Ăn uống');
        await widgetTester.enterText(find.byType(EtTextField).last, '500000');

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
