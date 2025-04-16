import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:expense_tracking/presentation/features/setting/screen/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../authenticate/screen/biometric_login_test.mocks.dart';
import '../../transaction/create_transaction_screen_test.dart';


@GenerateMocks([UserBloc, LoadingCubit])
void main() {
  late UserBloc userBloc;
  late LoadingCubit loadingCubit;
  late User testUser;

  setUp(() {
    userBloc = MockUserBloc();
    loadingCubit = MockLoadingCubit();
    testUser = User('test_id', 'test@example.com', 5000, 'Nguyễn', 'Văn A', avatar: null);

    when(loadingCubit.state).thenReturn(false);
  });

  Widget createEditProfileScreen() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>.value(value: userBloc),
          BlocProvider<LoadingCubit>.value(value: loadingCubit),
        ],
        child: EditProfileScreen(user: testUser),
      ),
    );
  }

  group('EditProfileScreen UI Test', () {
    testWidgets('should render correctly with user data', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(createEditProfileScreen());

      // Check if the appbar title is correct
      expect(find.text('Chỉnh sửa thông tin'), findsOneWidget);

      // Check if the email is displayed
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);

      // Check if name fields are displayed with correct initial data
      expect(find.text('Họ'), findsOneWidget);
      expect(find.text('Tên'), findsOneWidget);

      // Verify TextFields are populated with user data
      final firstNameField = find.byWidgetPredicate(
        (widget) => widget is EtTextField && widget.label == 'Họ',
      );
      expect(firstNameField, findsOneWidget);
      expect(
        (tester.widget(firstNameField) as EtTextField).controller.text,
        'Nguyễn',
      );

      final lastNameField = find.byWidgetPredicate(
        (widget) => widget is EtTextField && widget.label == 'Tên',
      );
      expect(lastNameField, findsOneWidget);
      expect(
        (tester.widget(lastNameField) as EtTextField).controller.text,
        'Văn A',
      );

      // Check if save button exists
      expect(find.text('Lưu thay đổi'), findsOneWidget);
    });

    testWidgets('should show validation errors when fields are empty', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(createEditProfileScreen());

      // Clear text fields
      await tester.enterText(find.byWidgetPredicate(
        (widget) => widget is EtTextField && widget.label == 'Họ',
      ), '');
      await tester.enterText(find.byWidgetPredicate(
        (widget) => widget is EtTextField && widget.label == 'Tên',
      ), '');

      // Tap save button
      await tester.tap(find.text('Lưu thay đổi'));
      await tester.pump();

      // Check if validation error messages are shown
      expect(find.text('Vui lòng nhập họ của bạn'), findsOneWidget);
      expect(find.text('Vui lòng nhập tên của bạn'), findsOneWidget);
    });

    testWidgets('should call update user when form is valid', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(createEditProfileScreen());

      // Update text fields
      await tester.enterText(find.byWidgetPredicate(
        (widget) => widget is EtTextField && widget.label == 'Họ',
      ), 'Trần');
      await tester.enterText(find.byWidgetPredicate(
        (widget) => widget is EtTextField && widget.label == 'Tên',
      ), 'Văn B');

      // Mock loading cubit behavior
      when(loadingCubit.showLoading()).thenAnswer((_) async {});
      when(loadingCubit.hideLoading()).thenAnswer((_) async {});

      // Tap save button
      await tester.tap(find.text('Lưu thay đổi'));
      await tester.pump();

      // Verify loading indicators were shown and hidden
      verify(loadingCubit.showLoading()).called(1);
      
      // Verify user bloc was called with updated user information
      verify(userBloc.add(argThat(
        isA<UpdateUserEvent>().having(
          (event) => event.user.firstName, 'firstName', 'Trần'
        ).having(
          (event) => event.user.lastName, 'lastName', 'Văn B'
        ),
      ))).called(1);
    });

    testWidgets('should have a back button in AppBar', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(createEditProfileScreen());

      // Find the back button
      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);

      // Tap the back button
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify navigation (widget should be removed from screen)
      expect(find.byType(EditProfileScreen), findsNothing);
    });

    testWidgets('should have a camera button for avatar selection', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(createEditProfileScreen());

      // Find the camera icon
      final cameraIcon = find.byIcon(Icons.camera_alt);
      expect(cameraIcon, findsOneWidget);
    });
  });
} 