import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../dtos/wifi_config_dto.dart';

/// Mirrors [WifiConfigController] — GET and POST /api/setup/wifi-config.
///
/// No PUT or DELETE: WiFi credentials are never stored; nothing to update or remove.
@injectable
class WifiConfigServiceClient {
  WifiConfigServiceClient(DioClient client) : _dio = client.dio;

  final Dio _dio;

  static const _path = '/api/setup/wifi-config';

  /// Returns current connectivity status. Never includes credentials.
  Future<WifiStatusDto> getStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(_path);
    return WifiStatusDto.fromJson(response.data!);
  }

  /// Attempts to connect to a network. [password] may be null for open networks.
  Future<WifiConnectionResultDto> connect({
    required String networkName,
    String? password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _path,
      data: {'networkName': networkName, 'password': password},
    );
    return WifiConnectionResultDto.fromJson(response.data!);
  }
}
