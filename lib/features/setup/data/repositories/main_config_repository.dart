import 'package:injectable/injectable.dart';

import '../../data/clients/main_config_service_client.dart';
import '../../data/dtos/main_config_dto.dart';
import '../../domain/entities/main_config.dart';
import '../../domain/repositories/i_main_config_repository.dart';

/// Implements [IMainConfigRepository] using [MainConfigServiceClient].
///
/// Maps DTOs to domain entities at this boundary.
/// DTO types must not leak above this class.
@Injectable(as: IMainConfigRepository)
class MainConfigRepository implements IMainConfigRepository {
  const MainConfigRepository(this._client);

  final MainConfigServiceClient _client;

  @override
  Future<MainConfig?> get() async {
    final dto = await _client.get();
    return dto == null ? null : _toEntity(dto);
  }

  @override
  Future<MainConfig> create({
    required String greenhouseName,
    required String location,
    String? description,
  }) async {
    final dto = await _client.post(
      MainConfigRequestDto(
        greenhouseName: greenhouseName,
        location: location,
        description: description,
      ),
    );
    return _toEntity(dto);
  }

  static MainConfig _toEntity(MainConfigDto dto) => MainConfig(
        greenhouseName: dto.greenhouseName,
        location: dto.location,
        description: dto.description,
      );
}
