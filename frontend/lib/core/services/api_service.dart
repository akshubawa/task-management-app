// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:task_management/core/constants/endpoints.dart';
import 'package:task_management/core/services/local_storage.dart';
import 'package:task_management/core/utils/jwt_utils.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;

  /// Seconds before expiry to consider token "expiring" and refresh proactively.
  static const int _tokenExpiryBufferSeconds = 300; // 5 minutes

  /// Paths that must not trigger token refresh (unauthenticated or refresh itself).
  static const List<String> _noRefreshPaths = ['auth/login', 'auth/register', 'auth/refresh'];

  Future<void>? _refreshFuture;

  // Your base URL - configure this
  static const String baseUrl = 'http://localhost:3000';

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _initializeInterceptors();
  }

  bool _isNoRefreshPath(String path) {
    return _noRefreshPaths.any((p) => path.contains(p));
  }

  /// Refreshes access token using refresh token. Throws on failure.
  Future<void> _refreshAccessToken() async {
    final refreshToken = await LocalStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(path: Endpoints.refresh),
        type: DioExceptionType.badResponse,
        message: 'No refresh token available',
      );
    }
    final path = Endpoints.refresh.startsWith('/')
        ? Endpoints.refresh
        : '/${Endpoints.refresh}';
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: {'refreshToken': refreshToken},
      options: Options(extra: <String, dynamic>{'skipAuth': true}),
    );
    final data = response.data;
    final accessToken = data != null ? data['accessToken'] as String? : null;
    if (accessToken == null || accessToken.isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        message: 'Invalid refresh response: no accessToken',
      );
    }
    await LocalStorage.setAccessToken(accessToken);
    setAuthToken(accessToken);
    if (kDebugMode) {
      print('✅ Access token refreshed successfully');
    }
  }

  /// Ensures at most one refresh in flight; others wait for it.
  Future<void> _performRefreshIfNeeded() async {
    final current = _refreshFuture;
    if (current != null) {
      await current;
      return;
    }
    final completer = _refreshAccessToken();
    _refreshFuture = completer;
    try {
      await completer;
    } finally {
      _refreshFuture = null;
    }
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final path = options.path;
          if (options.extra['skipAuth'] == true) {
            options.headers['Authorization'] = null;
            return handler.next(options);
          }
          if (_isNoRefreshPath(path)) {
            return handler.next(options);
          }
          String? accessToken = await LocalStorage.getAccessToken();
          if (accessToken == null || accessToken.isEmpty) {
            return handler.next(options);
          }
          if (isTokenExpiredOrExpiring(accessToken, bufferSeconds: _tokenExpiryBufferSeconds)) {
            try {
              await _performRefreshIfNeeded();
              accessToken = await LocalStorage.getAccessToken();
            } catch (e) {
              if (kDebugMode) {
                print('⚠️ Token refresh failed before request: $e');
              }
              return handler.next(options);
            }
          }
          // Always attach current token from storage so we never send a stale header
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode != 401) {
            return handler.next(error);
          }
          if (_isNoRefreshPath(error.requestOptions.path)) {
            return handler.next(error);
          }
          try {
            await _performRefreshIfNeeded();
            final newToken = await LocalStorage.getAccessToken();
            if (newToken == null || newToken.isEmpty) {
              return handler.next(error);
            }
            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            final response = await _dio.fetch(opts);
            return handler.resolve(response);
          } catch (_) {
            return handler.next(error);
          }
        },
      ),
    );
  }

  // Set token after login
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    if (kDebugMode) {
      print('✅ Token set in ApiService: Bearer ${token.substring(0, 20)}...');
      print('Current headers: ${_dio.options.headers}');
    }
  }

  // Initialize token from storage (call on app start)
  Future<void> initializeToken() async {
    final token = await LocalStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      setAuthToken(token);
      if (kDebugMode) {
        print('✅ Token initialized from storage');
      }
    } else {
      if (kDebugMode) {
        print('⚠️ No token found in storage');
      }
    }
  }

  // Clear token on logout
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Helper method to get headers with or without Authorization
  Map<String, dynamic>? _getHeaders(bool requiresAuth) {
    if (requiresAuth) {
      return null; // Use default headers with Authorization
    } else {
      // Return empty headers for unauthenticated requests (no headers at all)
      return <String, dynamic>{};
    }
  }

  // GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      // Ensure endpoint starts with '/' for proper URL construction
      final normalizedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';

      final response = await _dio.get(
        normalizedEndpoint,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(requiresAuth)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      // Ensure endpoint starts with '/' for proper URL construction
      final normalizedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';
      final fullUrl = '$baseUrl$normalizedEndpoint';

      if (kDebugMode) {
        print('POST request endpoint: $normalizedEndpoint');
        print('Full URL: $fullUrl');
        print('Data: $data');
        print('Query parameters: $queryParameters');
        print('Requires auth: $requiresAuth');
      }

      final response = await _dio.post(
        normalizedEndpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(requiresAuth)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request with URL-encoded form data
  Future<Response> postUrlEncoded(
    String endpoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      // Ensure endpoint starts with '/' for proper URL construction
      final normalizedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';
      final fullUrl = '$baseUrl$normalizedEndpoint';

      // Manually encode the data as URL-encoded string
      final encodedData = data.entries
          .map(
            (entry) =>
                '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}',
          )
          .join('&');

      if (kDebugMode) {
        print('POST URL-encoded request endpoint: $normalizedEndpoint');
        print('Full URL: $fullUrl');
        print('Data (map): $data');
        print('Encoded data: $encodedData');
        print('Query parameters: $queryParameters');
        print('Requires auth: $requiresAuth');
      }

      final headers = _getHeaders(requiresAuth) ?? {};
      headers['Content-Type'] = 'application/x-www-form-urlencoded';

      final response = await _dio.post(
        normalizedEndpoint,
        data: encodedData,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          contentType: 'application/x-www-form-urlencoded',
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      // Ensure endpoint starts with '/' for proper URL construction
      final normalizedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';
      final fullUrl = '$baseUrl$normalizedEndpoint';

      if (kDebugMode) {
        print('PUT request endpoint: $normalizedEndpoint');
        print('Full URL: $fullUrl');
        print('Data: $data');
        print('Query parameters: $queryParameters');
        print('Requires auth: $requiresAuth');
      }

      final response = await _dio.put(
        normalizedEndpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(requiresAuth)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final normalizedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';
      final response = await _dio.patch(
        normalizedEndpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(requiresAuth)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      // Ensure endpoint starts with '/' for proper URL construction
      final normalizedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';
      final fullUrl = '$baseUrl$normalizedEndpoint';

      if (kDebugMode) {
        print('DELETE request endpoint: $normalizedEndpoint');
        print('Full URL: $fullUrl');
        print('Data: $data');
        print('Query parameters: $queryParameters');
        print('Requires auth: $requiresAuth');
      }

      final response = await _dio.delete(
        normalizedEndpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(requiresAuth)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST Multipart/FormData request
  Future<Response> postFormData(
    String endpoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      // Ensure endpoint starts with '/' for proper URL construction
      final normalizedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';
      final fullUrl = '$baseUrl$normalizedEndpoint';

      if (kDebugMode) {
        print('POST FormData request endpoint: $normalizedEndpoint');
        print('Full URL: $fullUrl');
        print('Query parameters: $queryParameters');
        print('Requires auth: $requiresAuth');
      }

      final formData = FormData.fromMap(data);

      // Don't set Content-Type header manually - Dio will set it automatically with boundary
      final response = await _dio.post(
        normalizedEndpoint,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        options: Options(headers: _getHeaders(requiresAuth)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT Multipart/FormData request
  Future<Response> putFormData(
    String endpoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      // Ensure endpoint starts with '/' for proper URL construction
      final normalizedEndpoint = endpoint.startsWith('/')
          ? endpoint
          : '/$endpoint';
      final fullUrl = '$baseUrl$normalizedEndpoint';

      if (kDebugMode) {
        print('PUT FormData request endpoint: $normalizedEndpoint');
        print('Full URL: $fullUrl');
        print('Query parameters: $queryParameters');
        print('Requires auth: $requiresAuth');
      }

      final formData = FormData.fromMap(data);

      // Don't set Content-Type header manually - Dio will set it automatically with boundary
      final response = await _dio.put(
        normalizedEndpoint,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        options: Options(headers: _getHeaders(requiresAuth)),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handler
  String _handleError(DioException error) {
    String errorMessage = '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timeout. Please try again.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(error.response?.statusCode, error);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad certificate';
        break;
      case DioExceptionType.unknown:
        // Try to get more details from the error
        if (error.message != null && error.message!.isNotEmpty) {
          errorMessage = error.message!;
        } else if (error.response != null) {
          errorMessage = _handleStatusCode(error.response?.statusCode, error);
        } else {
          errorMessage =
              'Network error. Please check your internet connection and try again.';
        }
        break;
    }

    return errorMessage;
  }

  String _handleStatusCode(int? statusCode, DioException error) {
    // Extract message from response data
    String? message;
    if (error.response?.data != null) {
      final responseData = error.response!.data;
      if (responseData is Map<String, dynamic>) {
        message = responseData['message'] as String?;
      }
    }

    switch (statusCode) {
      case 400:
        return message ?? 'Bad request';
      case 401:
        return message ?? 'Unauthorized. Please login again.';
      case 403:
        return message ?? 'Forbidden';
      case 404:
        return message ?? 'Not found';
      case 500:
        return message ?? 'Internal server error';
      case 502:
        return message ?? 'Bad gateway';
      default:
        return message ?? 'Something went wrong';
    }
  }
}
