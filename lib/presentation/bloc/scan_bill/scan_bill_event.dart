part of 'scan_bill_bloc.dart';

@immutable
sealed class ScanBillEvent {}

class ScanBill extends ScanBillEvent {
  late final String imagePath;
  late final List<Category> categories;

  ScanBill(this.imagePath, this.categories);
}

class ScanBillInitialEvent extends ScanBillEvent {}
