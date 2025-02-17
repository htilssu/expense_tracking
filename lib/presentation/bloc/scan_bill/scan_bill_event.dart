part of 'scan_bill_bloc.dart';

@immutable
sealed class ScanBillEvent {}

class ScanBill extends ScanBillEvent {
  final XFile image;

  ScanBill(this.image);
}
