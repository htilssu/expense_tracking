part of 'scan_bill_bloc.dart';

@immutable
sealed class ScanBillState {}

final class ScanBillInitial extends ScanBillState {}

final class BillScanned extends ScanBillState {
  final Transaction transaction;

  BillScanned(this.transaction);
}

final class BillLoading extends ScanBillState {
  BillLoading();
}
