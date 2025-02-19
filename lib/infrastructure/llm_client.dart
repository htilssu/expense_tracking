import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';


abstract class LlmClient {
  /// Send a request to server to llm to analyze the text
  /// to get the transaction information
  Future<BillInfo> analyzeText(String text, List<Category> category);
}
