import 'dart:convert';

import 'package:expense_tracking/utils/logging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../domain/entity/transaction.dart';

class LlmClient {
  /// Send a request to server to llm to analyze the text
  /// to get the transaction information
  Future<Transaction> analyzeText(String text) async {
    final url = Uri.parse('http://localhost:8080/classify');

    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "text": text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Transaction.fromMap(responseData);
      } else {
        if (kDebugMode) {
          Logger.error("Response code is not 200");
        }

        return Future.error("Response code is not 200");
      }
    } catch (e) {
      if (kDebugMode) {
        Logger.error(e.toString());
      }
      return Future.error(e);
    }
  }
}
