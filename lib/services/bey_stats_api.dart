import 'dart:convert';
import 'package:bey_stats/services/logger.dart';
import 'package:http/http.dart' as http;

class BeyStatsApi {
  static Future<String> setBugReport(String json) async {
    final url = Uri.parse('https://beystats.nekosyndicate.com/issues');

    try {
      // Send the JSON string as the body of the POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json,
      );

      if (response.statusCode == 201) {
        // Successfully created issue, parse the response
        final responseData = jsonDecode(response.body);
        Logger.info('Issue created with ID: ${responseData['id']}');
        return responseData['id'] as String;
      } else {
        Logger.error('Failed to create issue: ${response.statusCode}');
        throw Exception('Failed to create issue: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Error sending JSON to server: $e');
      throw Exception('Error sending JSON to server: $e');
    }
  }
}
