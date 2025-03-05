import 'package:expense_tracking/domain/dto/overview_data.dart';

abstract class AnalysisService {
  Future<OverviewData> getOverviewData();
}
