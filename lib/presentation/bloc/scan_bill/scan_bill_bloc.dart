import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:expense_tracking/domain/entity/transaction.dart';
import 'package:expense_tracking/infrastructure/llm_client.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:expense_tracking/utils/text_recognizer.dart';
import 'package:flutter/foundation.dart';

part 'scan_bill_event.dart';

part 'scan_bill_state.dart';

class ScanBillBloc extends Bloc<ScanBillEvent, ScanBillState> {
  final LlmClient _llmClient = LlmClient();

  ScanBillBloc() : super(ScanBillInitial()) {
    on<ScanBill>(_scanBill);
    on<ScanBillInitialEvent>(_scanBillInitial);
  }

  void _scanBill(ScanBill scanBill, Emitter<ScanBillState> emit) async {
    emit(BillLoading());
    var textScanned = await TextRecognizerUtil.recognize(scanBill.imagePath);
    try {
      var transaction = await _llmClient.analyzeText(textScanned);
      emit(BillScanned(transaction));
    } catch (e) {
      if (kDebugMode) {
        Logger.error(e.toString());
      }
      emit(ScanBillInitial());
    }
  }

  void _scanBillInitial(
      ScanBillInitialEvent scanBill, Emitter<ScanBillState> emit) async {
    emit(ScanBillInitial());
  }
}
