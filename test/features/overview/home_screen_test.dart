import 'package:expense_tracking/application/service/transaction_service_impl.dart';
import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/domain/service/transaction_service.dart';
import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:expense_tracking/presentation/features/overview/screen/home_screen.dart';
import 'package:expense_tracking/presentation/features/overview/widget/et_home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([
  TransactionServiceImpl,
])
void main() {
  TransactionService mockService = MockTransactionServiceImpl();
  late UserBloc userBloc;

  setUp(() {
    userBloc = MockUserBloc();
    whenListen(userBloc, Stream<UserState>.empty(),
        initialState: UserLoaded(
            user: User("123", "fullName", "email", "firstName", "lastName")));
  });

  Widget createHomeScreen() {
    return MaterialApp(
        home: MultiBlocProvider(
            providers: [
          BlocProvider(
            create: (context) => userBloc,
          )
        ],
            child: HomeScreen(
              transactionService: mockService,
            )));
  }

  testWidgets('HomeScreen has appbar', (WidgetTester tester) async {
    when(mockService.getRecentTransactionsByUserId())
        .thenAnswer((_) => Future.value([]));
    await tester.pumpWidget(createHomeScreen());
    expect(find.byType(EtHomeAppbar), findsOneWidget);
  });
}

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}
