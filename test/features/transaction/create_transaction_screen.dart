import 'package:bloc_test/bloc_test.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:expense_tracking/application/service/creation_transaction_service_impl.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/create_transaction_screen.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/scan_bill_screen.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/amount_input.dart';
import 'package:expense_tracking/presentation/features/transaction/widget/note_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_transaction_screen.mocks.dart';

@GenerateMocks([CreationTransactionServiceImpl])
void main() {
  late MockCreationTransactionServiceImpl mockService;
  late MockScanBillBloc mockScanBillBloc;
  late MockLoadingCubit mockLoadingCubit;
  late MockCategorySelectorCubit mockCategoryCubit;

  setUp(() {
    mockService = MockCreationTransactionServiceImpl();
    mockScanBillBloc = MockScanBillBloc();
    mockLoadingCubit = MockLoadingCubit();
    mockCategoryCubit = MockCategorySelectorCubit();

    // Mock initial states
    whenListen(
      mockScanBillBloc,
      Stream<ScanBillState>.value([] as ScanBillState),
      initialState: ScanBillInitial(),
    );

    whenListen(
      mockCategoryCubit,
      Stream<CategorySelectorState>.value([] as CategorySelectorState),
      initialState: IncomeCategory(),
    );
  });

  Widget createScreen() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: mockScanBillBloc),
          BlocProvider.value(value: mockLoadingCubit),
          BlocProvider.value(value: mockCategoryCubit),
        ],
        child: CreateTransactionScreen(creationTransactionService: mockService),
      ),
    );
  }

  group('CreateTransactionScreen Widget Tests', () {
    testWidgets('Hiển thị UI ban đầu', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Tạo giao dịch'), findsOneWidget);
      expect(find.byType(CustomSlidingSegmentedControl<int>), findsOneWidget);
      expect(find.text('Thu nhập'), findsOneWidget);
      expect(find.text('Chi tiêu'), findsOneWidget);
      expect(find.byType(AmountInput), findsOneWidget);
      expect(find.byType(NoteInput), findsOneWidget);
      expect(find.text('Danh mục'), findsOneWidget);
      expect(find.text('Lưu'), findsOneWidget);
    });

    testWidgets('Thay đổi segment từ income sang expense reset category',
        (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Thu nhập', skipOffstage: false), findsOneWidget);

      await tester.tap(find.text('Chi tiêu'));
      await tester.pumpAndSettle();

      expect(find.text('Chi tiêu', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Nhập amount và note', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(AmountInput), '500');
      await tester.pump();
      await tester.enterText(find.byType(NoteInput), 'Test Note');
      await tester.pump();

      expect(find.text('500'), findsOneWidget);
      expect(find.text('Test Note'), findsOneWidget);
    });

    testWidgets('Điều hướng đến ScanBillScreen khi nhấn nút scan',
        (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.document_scanner_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(ScanBillScreen), findsOneWidget);
    });

    testWidgets('Hiển thị loading khi ScanBillBloc ở trạng thái BillLoading',
        (tester) async {
      whenListen(
        mockScanBillBloc,
        Stream.value(BillLoading()),
        initialState: ScanBillInitial(),
      );
      when(mockLoadingCubit.showLoading()).thenAnswer((_) {});

      await tester.pumpWidget(createScreen());
      await tester.pump();

      verify(mockLoadingCubit.showLoading()).called(1);
    });

    testWidgets('Cập nhật UI khi ScanBillBloc ở trạng thái BillScanned',
        (tester) async {
      final billInfo = BillInfo(
        1000.0,
        DateTime.now(),
        'Test Store',
        Category('Food', 0, 0, 'expense', 'user1', icon: 'food'),
        'Scanned Bill',
      );
      whenListen(
        mockScanBillBloc,
        Stream.fromIterable([BillScanned(billInfo)]),
        initialState: ScanBillInitial(),
      );
      when(mockLoadingCubit.hideLoading()).thenAnswer((_) {});

      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('1000'), findsOneWidget);
      expect(find.text('Scanned Bill'), findsOneWidget);
      expect(find.text('Chi tiêu'), findsOneWidget);
      verify(mockLoadingCubit.hideLoading()).called(1);
    });

    testWidgets('Ẩn loading khi ScanBillBloc ở trạng thái ScanBillInitial',
        (tester) async {
      when(mockLoadingCubit.hideLoading()).thenAnswer((_) {});

      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      verify(mockLoadingCubit.hideLoading()).called(1);
    });
  });
}

class MockScanBillBloc extends MockBloc<ScanBillEvent, ScanBillState>
    implements ScanBillBloc {}

class MockLoadingCubit extends MockCubit<LoadingState>
    implements LoadingCubit {}

class MockCategorySelectorCubit extends MockCubit<CategorySelectorState>
    implements CategorySelectorCubit {}
