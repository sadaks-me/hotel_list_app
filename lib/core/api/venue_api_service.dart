import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

class VenueApiService {
  final Dio _dio;
  final String baseUrl;

  VenueApiService({
    required this.baseUrl,
    required Directory cacheDir,
    Dio? dio,
  }) : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl)) {
    if (dio == null) {
      try {
        _dio.interceptors.add(
          DioCacheInterceptor(
            options: CacheOptions(
              store: HiveCacheStore(cacheDir.path),
              policy: CachePolicy.forceCache,
              priority: CachePriority.high,
              maxStale: const Duration(days: 7),
              hitCacheOnErrorExcept: [401, 403],
              keyBuilder: (request) =>
                  request.uri.toString() + (request.data?.toString() ?? ''),
            ),
          ),
        );
      } catch (e) {
        print('Cache initialization failed: $e');
        // Continue without cache if initialization fails
      }
    }
  }

  Future<Map<String, dynamic>> fetchVenues({required String endpoint}) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          extra: {'cacheKey': endpoint},
          // Add a timeout
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      throw Exception('Unexpected API response format');
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.connectionError) {
        // Handle connection errors specifically
        throw Exception('Connection error: Please check your internet connection');
      }
      rethrow;
    }
  }
}
