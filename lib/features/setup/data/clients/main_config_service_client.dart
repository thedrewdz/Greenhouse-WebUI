import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../dtos/main_config_dto.dart';

/// Mirrors [MainConfigController] — GET, POST, PUT, DELETE /api/setup/main-config.
@injectable
class MainConfigServiceClient {
  MainConfigServiceClient(DioClient client) : _dio = client.dio;

  final Dio _dio;

  static const _path = '/api/setup/main-config';

  /// Returns current [MainConfigDto], or null (404) when not yet configured.
  Future<MainConfigDto?> get() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(_path);
      return MainConfigDto.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Creates the initial config. Throws [DioException] with status 409 if
  /// config already exists.
  Future<MainConfigDto> post(MainConfigRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _path,
      data: request.toJson(),
    );
    return MainConfigDto.fromJson(response.data!);
  }

  /// Updates existing config. Deferred — returns 501 until services implements it.
  Future<MainConfigDto> put(MainConfigRequestDto request) async {
    final response = await _dio.put<Map<String, dynamic>>(
      _path,
      data: request.toJson(),
    );
    return MainConfigDto.fromJson(response.data!);
  }

  /// Deletes config. Deferred — returns 501 until services implements it.
  Future<void> delete() async {
    await _dio.delete<void>(_path);
  }
}
