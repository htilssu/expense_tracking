import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/repository/category_repository.dart';
import 'package:expense_tracking/infrastructure/repository/category_repository_impl.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/features/category/create_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<CategoryRepositoryImpl>(),
  MockSpec<CategorySelectorCubit>(),
  MockSpec<CategoryBloc>(),
])
import 'create_category_screen_test.mocks.dart';

void main() {
  late CategoryRepository mockCategoryRepository;
  late MockCategorySelectorCubit mockCubit;
  late MockCategoryBloc mockCategoryBloc;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();

    provideDummy<CategoryState>(CategoryInitial());
    provideDummy<CategorySelectorState>(IncomeCategory());

    mockCategoryRepository = MockCategoryRepositoryImpl();
    mockCubit = MockCategorySelectorCubit();
    mockCategoryBloc = MockCategoryBloc();

    when(mockCategoryBloc.stream)
        .thenAnswer((_) => Stream<CategoryState>.fromIterable([CategoryInitial()]));

    when(mockCategoryBloc.state).thenReturn(CategoryInitial());

    when(mockCubit.state).thenReturn(IncomeCategory());
    when(mockCubit.stream)
        .thenAnswer((_) => Stream<CategorySelectorState>.fromIterable([IncomeCategory()]));
  });

  group('_isCategoryNameExist', () {
    testWidgets('Trả về true nếu danh mục đã tồn tại', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<CategoryBloc>(
                create: (_) => mockCategoryBloc,
              ),
              BlocProvider<CategorySelectorCubit>(
                create: (_) => mockCubit,
              ),
            ],
            child: CreateCategoryScreen(categoryRepository: mockCategoryRepository),
          ),
        ),
      );

      final state = tester.state<CreateCategoryScreenState>(find.byType(CreateCategoryScreen));

      state.categories = [
        Category('Ăn uống', 0, 100, 'expense', '1'),
        Category('Giải trí', 0, 200, 'expense', '2'),
      ];

      expect(state.isCategoryNameExist('Ăn uống'), isTrue);
      expect(state.isCategoryNameExist('Giải trí'), isTrue);
    });

    testWidgets('Trả về false nếu danh mục chưa tồn tại', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<CategoryBloc>(
                create: (_) => mockCategoryBloc,
              ),
              BlocProvider<CategorySelectorCubit>(
                create: (_) => mockCubit,
              ),
            ],
            child: CreateCategoryScreen(categoryRepository: mockCategoryRepository),
          ),
        ),
      );

      final state = tester.state<CreateCategoryScreenState>(find.byType(CreateCategoryScreen));

      state.categories = [
        Category('Ăn uống', 0, 100, 'expense', '1'),
        Category('Giải trí', 0, 200, 'expense', '2'),
      ];

      expect(state.isCategoryNameExist('Du lịch'), isFalse);
    });
  });
}
