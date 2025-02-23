import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/infrastructure/image_analyze_client.dart';
import 'package:expense_tracking/infrastructure/llm_client.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:http/http.dart';

import '../utils/logging.dart';

class GeminiClient extends LlmClient implements ImageAnalyzeClient {
  Uri textEndpoint =
      Uri.parse('https://expensetrackingserver.vercel.app/gemini/text');
  Uri imageEndpoint =
      Uri.parse('https://expensetrackingserver.vercel.app/gemini/image');

  @override
  Future<BillInfo> analyzeText(String text, List<Category> category) async {
    try {
      var res = await post(textEndpoint,
          headers: {"Content-Type": "application/json;charset=utf-8"},
          body: jsonEncode({
            'text': text,
            'category': category
                .map(
                  (e) => e.name,
                )
                .toList(),
          })).timeout(Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = utf8.decode(res.bodyBytes);
        var jsonMap = jsonDecode(body) as Map<String, dynamic>;

        var tCategory = category.firstWhere(
          (element) {
            return element.name == jsonMap["category"];
          },
        );

        return BillInfo(
          (jsonMap["money"] as int).toDouble(),
          DateTime.tryParse(jsonMap["date"]) ?? DateTime.now(),
          jsonMap["store"] ?? "",
          tCategory,
          jsonMap["note"] ?? "",
        );
      } else {
        throw Exception('Failed to analyze text');
      }
    } on TimeoutException catch (e) {
      Logger.error("Timeout: $e");
      return Future.error("Timeout: $e");
    }
  }

  @override
  Future<BillInfo> analyzeImage(
      String imagePath, List<Category> category) async {
    try {
      var res = await post(imageEndpoint,
          headers: {"Content-Type": "application/json;charset=utf-8"},
          body: jsonEncode({
            'image': File(imagePath).readAsBytesSync(),
            'category': category
                .map(
                  (e) => e.name,
                )
                .toList(),
          })).timeout(Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = utf8.decode(res.bodyBytes);
        var jsonMap = jsonDecode(body) as Map<String, dynamic>;

        var tCategory = category.firstWhere(
          (element) {
            return element.name == jsonMap["category"];
          },
        );

        return BillInfo(
          (jsonMap["money"] as int).toDouble(),
          DateTime.tryParse(jsonMap["date"]) ?? DateTime.now(),
          jsonMap["store"] ?? "",
          tCategory,
          jsonMap["note"] ?? "",
        );
      } else {
        throw Exception('Failed to analyze text');
      }
    } on TimeoutException catch (e) {
      Logger.error("Timeout: $e");
      return Future.error("Timeout: $e");
    }
  }
}
