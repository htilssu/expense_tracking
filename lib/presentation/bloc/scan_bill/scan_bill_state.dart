part of 'scan_bill_bloc.dart';

@immutable
sealed class ScanBillState {}

final class ScanBillInitial extends ScanBillState {}

final class BillScanned extends ScanBillState {
  final BillInfo billInfo;

  BillScanned(this.billInfo);
}

final class BillLoading extends ScanBillState {
  BillLoading();
}

class BillInfo {
  final int money;
  final DateTime date;
  final String store;
  final Category category;
  final String note;

  BillInfo(this.money, this.date, this.store, this.category, this.note);
}
