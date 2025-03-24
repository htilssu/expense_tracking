import 'dart:async';
import 'dart:convert';

import 'package:expense_tracking/domain/entity/category.dart';
import 'package:expense_tracking/infrastructure/image_analyze_client.dart';
import 'package:expense_tracking/infrastructure/llm_client.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:http/http.dart';

import '../utils/logging.dart';

class GeminiClient implements ImageAnalyzeClient, LlmClient {
  Uri textEndpoint =
      Uri.parse('https://expensetrackingserver.vercel.app/gemini/text');
  Uri imageEndpoint =
      Uri.parse('https://expensetrackingserver.vercel.app/gemini/image');

  @override
  Future<BillInfo> analyzeText(String text, List<Category> category) async {
    try {
      var res = await post(textEndpoint,
          headers: {
            'Content-Type': 'application/json;charset=utf-8',
            'User-Agent': 'TrezoApp',
          },
          body: jsonEncode({
            'text': text,
            'category': category
                .map(
                  (e) => e.name,
                )
                .toList(),
          })).timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = utf8.decode(res.bodyBytes);
        var jsonMap = jsonDecode(body) as Map<String, dynamic>;

        var tCategory = category.firstWhere(
          (element) {
            return element.name == jsonMap['category'];
          },
        );

        return BillInfo(
          (jsonMap['money'] as int),
          DateTime.tryParse(jsonMap['date']) ?? DateTime.now(),
          jsonMap['store'] ?? '',
          tCategory,
          jsonMap['note'] ?? '',
        );
      } else {
        throw Exception('Failed to analyze text');
      }
    } on TimeoutException catch (e) {
      Logger.error('Timeout: $e');
      return Future.error('Timeout: $e');
    }
  }

  @override
  Future<BillInfo> analyzeImage(
      String imagePath, List<Category> category) async {
    try {
      var request = MultipartRequest('POST', imageEndpoint);
      request.headers.addEntries([const MapEntry('User-Agent', 'TrezoApp')]);

      for (var i = 0; i < category.length; i++) {
        request.files.add(MultipartFile.fromString(
          'category',
          category[i].name,
        ));
      }

      var file = await MultipartFile.fromPath('image', imagePath);

      request.files.add(file);

      var res = await request.send().timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final body = await res.stream.bytesToString();
        var jsonMap = jsonDecode(body) as Map<String, dynamic>;

        var tCategory = category.firstWhere(
          (element) {
            return element.name == jsonMap['category'];
          },
        );

        var date = jsonMap['date'] != null
            ? DateTime.tryParse(jsonMap['date']) ?? DateTime.now()
            : DateTime.now();

        var money = jsonMap['money']['amount'];

        if (money is int) {
          money = money;
        } else if (money is double) {
          money = money.toInt();
        }

        return BillInfo(
          money,
          date,
          jsonMap['store'] ?? '',
          tCategory,
          jsonMap['note'] ?? '',
        );
      } else {
        throw Exception('Failed to analyze text');
      }
    } on TimeoutException catch (e) {
      Logger.error('Timeout: $e');
      return Future.error('Timeout: $e');
    }
  }
}
