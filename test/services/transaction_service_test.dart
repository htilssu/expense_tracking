import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/domain/repository/transaction_repository.dart';
import 'package:expense_tracking/domain/service/transaction_service.dart';
import 'package:expense_tracking/utils/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transaction_service_test.mocks.dart';

@GenerateMocks([TransactionRepository])
// Concrete implementation for testing
class TestTransactionService extends TransactionService {
  TestTransactionService(super.repository);
}

void main() {
  late MockTransactionRepository mockRepository;
  late TransactionService transactionService;

  setUp(() {
    mockRepository = MockTransactionRepository();
    transactionService = TestTransactionService(mockRepository);
    Auth.uidFunction = () => 'test-user-id';
  });

  group('TransactionService', () {
    test(
        'getRecentTransactionsByUserId should return transactions from repository',
        () async {
      // Arrange
      final expectedTransactions = [
        Transaction.withId('1', 'Grocery', 100, 'Food', 'test-user-id'),
        Transaction.withId('2', 'Restaurant', 200, 'Food', 'test-user-id'),
      ];

      when(mockRepository.findRecentByUserId('test-user-id', 1, 5))
          .thenAnswer((_) async => expectedTransactions);

      // Act
      final result = await transactionService.getRecentTransactionsByUserId();

      // Assert
      expect(result, equals(expectedTransactions));
      verify(mockRepository.findRecentByUserId('test-user-id', 1, 5)).called(1);
    });

    test('getRecentTransactionsByUserId should handle empty response',
        () async {
      // Arrange
      when(mockRepository.findRecentByUserId('test-user-id', 1, 5))
          .thenAnswer((_) async => []);

      // Act
      final result = await transactionService.getRecentTransactionsByUserId();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.findRecentByUserId('test-user-id', 1, 5)).called(1);
    });

    test('getRecentTransactionsByUserId should propagate exceptions', () async {
      // Arrange
      Auth.uidFunction = () => 'unknown_user';
      when(mockRepository.findRecentByUserId('unknown_user', 1, 5))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => transactionService.getRecentTransactionsByUserId(),
        throwsException,
      );
      verify(mockRepository.findRecentByUserId('unknown_user', 1, 5)).called(1);
    });
  });
}
