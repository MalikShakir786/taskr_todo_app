import 'package:dio/dio.dart';
import 'package:my_todo/constants/app_urls.dart';

import '../utils/utils.dart';

enum HttpMethod {
  get,
  post,
  put,
  delete,
}


class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${AppUrls.baseUrl}${AppUrls.path}',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<Response?> request({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      switch (method) {
        case HttpMethod.get:
          return await _dio.get(
            endpoint,
            queryParameters: queryParams,
            options: options,
          );

        case HttpMethod.post:
          return await _dio.post(
            endpoint,
            data: data,
            queryParameters: queryParams,
            options: options,
          );

        case HttpMethod.put:
          return await _dio.put(
            endpoint,
            data: data,
            queryParameters: queryParams,
            options: options,
          );

        case HttpMethod.delete:
          return await _dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParams,
            options: options,
          );
      }
    } on DioException catch (e) {
      print("API Error: ${e.message}");
      return null;
    }
  }
}