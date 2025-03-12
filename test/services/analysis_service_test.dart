import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracking/application/service/analysis_service_impl.dart';
import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/domain/repository/category_repository.dart';
import 'package:expense_tracking/utils/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

@GenerateMocks([CategoryRepository])
import 'analysis_service_test.mocks.dart';

void main() {
  late MockCategoryRepository mockCategoryRepository;
  late FirebaseFirestore mockFirestore;
  late AnalysisServiceImpl analysisService;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    mockFirestore = FakeFirebaseFirestore();

    // Mock Auth.uid
    Auth.uidFunction = () => 'test-user-id';

    analysisService = AnalysisServiceImpl(
      categoryRepository: mockCategoryRepository,
    );

    // Replace the Firebase reference with our mock
    analysisService.refTransaction = mockFirestore.collection('transactions');
  });

  group('AnalysisService', () {
    test(
        'getOverviewData should return correct data when queries succeed', () async {
      // Arrange
      final categories = [
        Category.withId('income1', 'Salary', 0, 5000, 'income', 'test-user-id'),
        Category.withId('income2', 'Bonus', 0, 1000, 'income', 'test-user-id'),
        Category.withId(
            'expense1', 'Food', 1500, 2000, 'expense', 'test-user-id'),
        Category.withId(
            'expense2', 'Transport', 800, 1000, 'expense', 'test-user-id'),
      ];

      when(mockCategoryRepository.getCategories()).thenAnswer((
          _) async => categories);

      // Add test data to fake Firestore
      await mockFirestore.collection('transactions').add({
        'user': 'test-user-id',
        'category': 'income1',
        'value': 4000,
        'createdAt': Timestamp.fromDate(DateTime.now())
      });

      await mockFirestore.collection('transactions').add({
        'user': 'test-user-id',
        'category': 'expense1',
        'value': 1500,
        'createdAt': Timestamp.fromDate(DateTime.now())
      });

      // Act
      final result = await analysisService.getOverviewData();

      // Assert
      expect(result.totalIncome, greaterThan(0));
      expect(result.totalExpense, greaterThan(0));
      expect(result.totalBalance,
          equals(1700)); // (5000 + 1000) - (2000 - 1500) - (1000 - 800)
    });

    test('getOverviewData should handle empty categories', () async {
      // Arrange
      when(mockCategoryRepository.getCategories()).thenAnswer((_) async => []);

      // Act
      final result = await analysisService.getOverviewData();

      // Assert
      expect(result.totalIncome, equals(0));
      expect(result.totalExpense, equals(0));
      expect(result.totalBalance, equals(0));
    });

    test('getOverviewData should handle repository exceptions', () async {
      // Arrange
      when(mockCategoryRepository.getCategories()).thenThrow(
          Exception('Repository error'));

      // Act & Assert
      expect(() => analysisService.getOverviewData(), throwsException);
    });
  });
}

// Mock class for Firebase if needed
class MockAggregateQuerySnapshot extends Mock
    implements AggregateQuerySnapshot {
  @override
  num? getSum(String field) =>
      super.noSuchMethod(
        Invocation.method(#getSum, [field]),
        returnValueForMissingStub: 0,
      ) as num?;
}
