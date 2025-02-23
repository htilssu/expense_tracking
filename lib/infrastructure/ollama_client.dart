import 'dart:async';
import 'dart:convert';

import 'package:expense_tracking/infrastructure/llm_client.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;

import '../domain/entity/category.dart';

class OllamaClient extends LlmClient {
  Uri url = Uri.parse('http://localhost:8080/ollama');

  @override
  Future<BillInfo> analyzeText(String text, List<Category> category) async {
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "text": text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return BillInfo(
            responseData["money"],
            responseData["date"],
            responseData["store"],
            responseData["category"],
            responseData["note"]);
      } else {
        if (foundation.kDebugMode) {
          Logger.error("Response code is not 200");
        }

        return Future.error("Response code is not 200");
      }
    } on TimeoutException catch (e) {
      if (foundation.kDebugMode) {
        Logger.error(e.toString());
      }
      return Future.error(e);
    }
  }
}
