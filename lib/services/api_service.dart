import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import '../constants/api_constants.dart';

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  Future<ApiResponse<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(
        queryParameters: {...ApiConstants.defaultParams, ...?queryParams},
      );

      final response = await client.get(uri);

      return ApiResponse(
        data: json.decode(response.body),
        statusCode: response.statusCode,
        error:
            response.statusCode != 200 ? 'Error: ${response.statusCode}' : null,
      );
    } catch (e) {
      return ApiResponse(error: 'Excepción: $e');
    }
  }
}
