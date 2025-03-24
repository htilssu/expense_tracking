import 'package:bloc_test/bloc_test.dart';
import 'package:expense_tracking/application/service/creation_transaction_service_impl.dart';
import 'package:expense_tracking/presentation/bloc/category_selector/category_selector_cubit.dart';
import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/create_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'create_transaction_screen_test.mocks.dart';

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
      Stream<ScanBillState>.value(ScanBillInitial()),
      initialState: ScanBillInitial(),
    );

    whenListen(
      mockCategoryCubit,
      Stream<CategorySelectorState>.value(IncomeCategory()),
      initialState: IncomeCategory(),
    );
  });

  Widget createScreen() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ScanBillBloc>(create: (_) => mockScanBillBloc),
          BlocProvider<LoadingCubit>(create: (_) => mockLoadingCubit),
          BlocProvider<CategorySelectorCubit>(create: (_) => mockCategoryCubit),
        ],
        child: CreateTransactionScreen(creationTransactionService: mockService),
      ),
    );
  }

  testWidgets('Thay đổi segment từ income sang expense reset category',
      (tester) async {
    await tester.pumpWidget(createScreen());
    await tester.pumpAndSettle();

    expect(find.text('Thu nhập', skipOffstage: false), findsOneWidget);

    await tester.tap(find.text('Chi tiêu'));
    await tester.pumpAndSettle();

    expect(find.text('Chi tiêu', skipOffstage: false), findsOneWidget);
  });
}

class MockScanBillBloc extends MockBloc<ScanBillEvent, ScanBillState>
    implements ScanBillBloc {}

class MockLoadingCubit extends MockCubit<LoadingState>
    implements LoadingCubit {}

class MockCategorySelectorCubit extends MockCubit<CategorySelectorState>
    implements CategorySelectorCubit {}
