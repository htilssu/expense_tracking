import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';

abstract class ImageAnalyzeClient {
  Future<BillInfo> analyzeImage(String imagePath, List<Category> category);
}
