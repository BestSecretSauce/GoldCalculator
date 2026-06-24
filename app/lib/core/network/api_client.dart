import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exceptions.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchLatestGoldPrice() async {
    final history = await fetchGoldPriceHistory();
    if (history.isEmpty) {
      throw const ApiException('No price data available');
    }
    return history.last;
  }

  Future<List<Map<String, dynamic>>> fetchGoldPriceHistory() async {
    final response = await _get('/api/gold_prices');
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const ApiException('No price data available');
    }
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> triggerRescrape() async {
    final uri = Uri.parse('$baseUrl/api/run_scraper');
    final response = await _send(() => _client.post(uri));
    if (response.statusCode != 200) {
      throw ApiException('Rescrape failed with status ${response.statusCode}');
    }
  }

  Future<http.Response> _get(String path) {
    final uri = Uri.parse('$baseUrl$path');
    return _send(() => _client.get(uri)).then((response) {
      if (response.statusCode != 200) {
        throw ApiException('Request failed with status ${response.statusCode}');
      }
      return response;
    });
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(const Duration(seconds: 30));
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const NetworkUnavailableException();
    }
  }
}
