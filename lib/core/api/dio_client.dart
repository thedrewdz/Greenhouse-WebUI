import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Central HTTP client configuration.
///
/// Annotated [@singleton] so injectable registers exactly one instance.
/// All service clients receive this via constructor injection.
/// Never instantiate [Dio] directly in a service client.
@singleton
class DioClient {
  DioClient() : dio = _build();

  final Dio dio;

  static Dio _build() {
    return Dio(
      BaseOptions(
        // Loopback only — services daemon and UI are on the same device.
        // Override with GREENHOUSE_API_URL env var for integration tests.
        baseUrl: const String.fromEnvironment(
          'GREENHOUSE_API_URL',
          defaultValue: 'http://127.0.0.1:5000',
        ),
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {'Content-Type': 'application/json'},
      ),
    )..interceptors.addAll([
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: _log,
        ),
      ]);
  }

  // ignore: avoid_print
  static void _log(Object message) => print('[DioClient] $message');
}
