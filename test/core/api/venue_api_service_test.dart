import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_list_app/core/api/venue_endpoints.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:hotel_list_app/core/api/venue_api_service.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
import 'venue_api_service_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late VenueApiService sut;
  late Directory tempDir;
  const baseUrl = 'https://mocki.io';
  const testEndpoint = '/v1/test-endpoint';

  setUp(() {
    mockDio = MockDio();
    tempDir = Directory.systemTemp;
    sut = VenueApiService(
      baseUrl: baseUrl,
      cacheDir: tempDir,
      dio: mockDio,
    );
  });

  group('fetchVenues', () {
    test('should return map when response is valid', () async {
      // arrange
      final expectedData = {
        'items': [
          {'id': 1, 'name': 'Test Venue'}
        ]
      };

      when(
        mockDio.get(
          testEndpoint,
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => Response(
            data: expectedData,
            statusCode: 200,
            requestOptions: RequestOptions(path: testEndpoint),
          ));

      // act
      final result = await sut.fetchVenues(endpoint: testEndpoint);

      // assert
      expect(result, equals(expectedData));
      verify(mockDio.get(testEndpoint, options: anyNamed('options'))).called(1);
    });

    test('should throw exception when response is not a map', () async {
      // arrange
      when(
        mockDio.get(
          testEndpoint,
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => Response(
            data: ['not a map'],
            statusCode: 200,
            requestOptions: RequestOptions(path: testEndpoint),
          ));

      // act & assert
      expect(
        () => sut.fetchVenues(endpoint: testEndpoint),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when dio throws error', () async {
      // arrange
      when(
        mockDio.get(
          testEndpoint,
          options: anyNamed('options'),
        ),
      ).thenThrow(DioException(
        requestOptions: RequestOptions(path: testEndpoint),
        error: 'Network error',
      ));

      // act & assert
      expect(
        () => sut.fetchVenues(endpoint: testEndpoint),
        throwsA(isA<DioException>()),
      );
    });

    test('should handle actual gyms endpoint response structure', () async {
      // arrange
      final expectedData = {
        'items': [
          {'id': 1, 'name': 'Gym 1', 'type': 'gym'},
          {'id': 2, 'name': 'Gym 2', 'type': 'gym'}
        ],
        'filters': [
          {
            'name': 'Category',
            'type': 'category',
            'categories': [
              {'id': 1, 'name': 'Fitness'},
              {'id': 2, 'name': 'Yoga'}
            ]
          }
        ]
      };

      when(
        mockDio.get(
          VenueEndpoints.gyms,
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => Response(
            data: expectedData,
            statusCode: 200,
            requestOptions: RequestOptions(path: VenueEndpoints.gyms),
          ));

      // act
      final result = await sut.fetchVenues(endpoint: VenueEndpoints.gyms);

      // assert
      expect(result, equals(expectedData));
      expect(result['items'], isA<List>());
      expect(result['filters'], isA<List>());
      verify(mockDio.get(VenueEndpoints.gyms, options: anyNamed('options'))).called(1);
    });
  });
}
