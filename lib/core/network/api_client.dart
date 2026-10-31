import 'package:dio/dio.dart';

import '../../app/constants/api_endpoints.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

typedef Json = Map<String, dynamic>;

class ApiClient {
  ApiClient(this._tokens, {void Function()? onUnauthorized})
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 40),
            receiveTimeout: const Duration(seconds: 40),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokens.read();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401 && _tokens.read() != null) {
            onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStorage _tokens;

  Future<Json> get(String path) => _send(() => _dio.get<Json>(path));

  Future<Json> post(String path, {Json? body}) => _send(() => _dio.post<Json>(path, data: body));

  Future<Json> put(String path, {Json? body}) => _send(() => _dio.put<Json>(path, data: body));

  Future<Json> delete(String path, {Json? body}) =>
      _send(() => _dio.delete<Json>(path, data: body));

  Future<Json> _send(Future<Response<Json>> Function() request) async {
    try {
      final response = await request();
      return (response.data?['data'] as Json?) ?? {};
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  ApiException _toException(DioException e) {
    final body = e.response?.data;
    if (body is Map && body['message'] is String) {
      return ApiException(body['message'] as String, statusCode: e.response?.statusCode);
    }
    final offline = e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout;
    return ApiException(
      offline ? 'Cannot reach the server. Check your connection.' : 'Something went wrong',
    );
  }
}
