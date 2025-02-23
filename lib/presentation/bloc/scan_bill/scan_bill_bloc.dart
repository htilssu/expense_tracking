import 'package:bloc/bloc.dart';
import 'package:expense_tracking/infrastructure/gemini_client.dart';
import 'package:expense_tracking/infrastructure/llm_client.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:expense_tracking/utils/text_recognizer.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:meta/meta.dart';

import '../../../domain/entity/category.dart';

part 'scan_bill_event.dart';

part 'scan_bill_state.dart';

class ScanBillBloc extends Bloc<ScanBillEvent, ScanBillState> {
  final LlmClient _llmClient = GeminiClient();

  ScanBillBloc() : super(ScanBillInitial()) {
    on<ScanBill>(_scanBill);
    on<ScanBillInitialEvent>(_scanBillInitial);
  }

  void _scanBill(ScanBill scanBill, Emitter<ScanBillState> emit) async {
    emit(BillLoading());
    var textScanned = await TextRecognizerUtil.recognize(scanBill.imagePath);

    if (foundation.kDebugMode) {
      Logger.info(textScanned);
    }

    try {
      var billInfo = await _llmClient.analyzeText(
          textScanned,
          scanBill.categories);
      emit(BillScanned(billInfo));
      return;
    } catch (e) {
      if (foundation.kDebugMode) {
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
