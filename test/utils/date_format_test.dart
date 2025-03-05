import 'package:expense_tracking/utils/date_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date', () {
    // Test case 1: Kiểm tra định dạng với một thời điểm cụ thể
    test('should format DateTime to HH:mm dd/MM correctly', () {
      // Arrange
      final dateTime = DateTime(2023, 10, 15, 14, 30); // 14:30 15/10/2023

      // Act
      final result = Date.format(dateTime);

      // Assert
      expect(result, '14:30 15/10');
    });

    // Test case 2: Kiểm tra định dạng với giờ và ngày khác
    test('should format DateTime with different hour and date correctly', () {
      // Arrange
      final dateTime = DateTime(2024, 3, 5, 9, 0); // 09:00 05/03/2024

      // Act
      final result = Date.format(dateTime);

      // Assert
      expect(result, '09:00 05/03');
    });

    // Test case 3: Kiểm tra định dạng với giờ 0 và ngày đầu tháng
    test('should format DateTime with zero hour and first day correctly', () {
      // Arrange
      final dateTime = DateTime(2025, 1, 1, 0, 0); // 00:00 01/01/2025

      // Act
      final result = Date.format(dateTime);

      // Assert
      expect(result, '00:00 01/01');
    });
  });
}
