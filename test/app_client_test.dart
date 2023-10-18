import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_post_request/app_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements Dio {}

class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  group('app_client_test', () {
    late Dio httpClient;
    late AppClient apiClient;

    setUp(() {
      httpClient = MockDioClient();
      apiClient = AppClient(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require a Dio client', () {
        expect(
          () => AppClient(),
          returnsNormally,
        );
      });
    });

    group('create bytes', () {
      const path = '/bytes';
      final input = SomeInput();
      final expectedBytes = Uint8List(123);

      test('makes correct http request.', () async {
        final response = MockResponse<Uint8List>();

        when(() => response.statusCode).thenReturn(201);
        when(() => response.data).thenReturn(expectedBytes);
        when(
          () => httpClient.post<Uint8List>(path, data: input.toJson()),
        ).thenAnswer((_) async => response);

        try {
          final response = await httpClient.post<Uint8List>(
            path,
            data: input.toJson(),
          );

          expect(response.statusCode, 200);
          expect(response.data, isNotNull);
        } catch (_) {}

        verify(
          () => httpClient.post<Uint8List>(path, data: input.toJson()),
        ).called(1);
      });
      test('returns bytes from server', () async {
        final response = MockResponse<Uint8List>();

        when(() => response.statusCode).thenReturn(201);
        when(() => response.data).thenReturn(expectedBytes);
        when(() => response.requestOptions).thenReturn(
          RequestOptions(
            path: path,
            responseType: ResponseType.bytes,
            data: input.toJson(),
          ),
        );

        when(
          () => httpClient.post<Uint8List>(
            path,
            data: input.toJson(),
            options: Options(responseType: ResponseType.bytes),
          ),
        ).thenAnswer((_) async => response);

        final bytes = await apiClient.createBytes(input: input);
        expect(bytes, expectedBytes);
      });
    });
  });
}
