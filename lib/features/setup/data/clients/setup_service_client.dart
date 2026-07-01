import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../dtos/setup_status_dto.dart';

/// Mirrors [SetupController] — GET /api/setup/status.
@injectable
class SetupServiceClient {
  SetupServiceClient(DioClient client) : _dio = client.dio;

  final Dio _dio;

  static const _path = '/api/setup/status';

  Future<SetupStatusDto> getStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(_path);
    return SetupStatusDto.fromJson(response.data!);
  }
}
