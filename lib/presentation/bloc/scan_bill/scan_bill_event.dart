part of 'scan_bill_bloc.dart';

@immutable
sealed class ScanBillEvent {}

class ScanBill extends ScanBillEvent {
  late final String imagePath;

  ScanBill(this.imagePath);
}

class ScanBillInitialEvent extends ScanBillEvent {}
