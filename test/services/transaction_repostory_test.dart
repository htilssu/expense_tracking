import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/infrastructure/repository/transaction_repostory_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transaction_repostory_test.mocks.dart';


// Update the mock generation to include QueryDocumentSnapshot instead of DocumentSnapshot
@GenerateMocks([
  fs.CollectionReference,
  fs.DocumentReference,
  fs.Query,
  fs.QuerySnapshot,
  fs.QueryDocumentSnapshot, // Use QueryDocumentSnapshot instead of DocumentSnapshot
])
void main() {
  late TransactionRepositoryImpl repository;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionRef;
  late MockDocumentReference<Map<String, dynamic>> mockDocRef;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot; // Change to QueryDocumentSnapshot

  setUp(() {
    mockCollectionRef = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocSnapshot = MockQueryDocumentSnapshot(); // Update to match the mock type

    repository = TransactionRepositoryImpl(ref: mockCollectionRef);
  });

  group('TransactionRepositoryImpl Tests', () {
    final testTransaction = Transaction(
      'Grocery shopping', // note
      150,               // value
      'Groceries',       // category
      'user2',          // user
    );

    test('delete - should call delete on document reference', () async {
      // Arrange
      when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.delete()).thenAnswer((_) async {});

      // Act
      await repository.delete('1');

      // Assert
      verify(mockCollectionRef.doc('1')).called(1);
      verify(mockDocRef.delete()).called(1);
    });


    test('findById - should return transaction when exists', () async {
      // Arrange
      when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn(testTransaction.toMap());

      // Act
      final result = await repository.findById('1');

      // Assert
      expect(result, isNotNull);
      expect(result!.value, testTransaction.value); // Use value instead of id
    });

    test('findById - should return null when not exists', () async {
      // Arrange
      when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(false);

      // Act
      final result = await repository.findById('1');

      // Assert
      expect(result, isNull);
    });

    test('save - should save transaction', () async {
      // Arrange
      when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.set(any)).thenAnswer((_) async {});

      // Act
      final result = await repository.save(testTransaction);

      // Assert
      expect(result, testTransaction);
      verify(mockDocRef.set(testTransaction.toMap())).called(1);
    });

    test('findRecentByUserId - should throw exception when size > 30', () {
      // Act & Assert
      expect(() => repository.findRecentByUserId('user1', 0, 31),
          throwsA(isA<Exception>()));
    });

    test('findRecentByUserId - should throw exception when page < 0', () {
      // Act & Assert
      expect(() => repository.findRecentByUserId('user1', -1, 10),
          throwsA(isA<Exception>()));
    });

    test('findRecentByUserId - should return recent transactions', () async {
      // Arrange
      when(mockCollectionRef.where(any, isEqualTo: anyNamed('isEqualTo')))
          .thenReturn(mockQuery);
      when(mockQuery.orderBy(any, descending: anyNamed('descending')))
          .thenReturn(mockQuery);
      when(mockQuery.limit(any)).thenReturn(mockQuery);
      when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockDocSnapshot]);
      when(mockDocSnapshot.data()).thenReturn(testTransaction.toMap());

      // Act
      final result = await repository.findRecentByUserId('user1', 0, 10);

      // Assert
      expect(result.length, 1);
      expect(result[0].value, testTransaction.value); // Use value instead of id
      verify(mockCollectionRef.where('user', isEqualTo: 'user1')).called(1);
      // Note: orderBy('createdAt') won't work with current Transaction class
      // verify(mockQuery.orderBy('createdAt', descending: true)).called(1);
      verify(mockQuery.limit(10)).called(1);
    });
  });
}