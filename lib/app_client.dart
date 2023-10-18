import 'dart:typed_data';

import 'package:dio/dio.dart';

class SomeInput {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }
}

class AppClient {
  AppClient({Dio? httpClient}) : _httpClient = httpClient ?? Dio();
  final Dio _httpClient;

  Future<Uint8List> createBytes({
    required SomeInput input,
  }) async {
    final uri = Uri.parse('/bytes');

    try {
      final response = await _httpClient.post<Uint8List>(
        uri.path,
        data: input.toJson(),
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      return response.data!;
    } on DioException catch (e) {
      throw Exception('DioError: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
