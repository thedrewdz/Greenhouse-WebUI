import '../entities/main_config.dart';
import '../repositories/i_main_config_repository.dart';

/// Writes the initial greenhouse configuration.
class WriteMainConfig {
  const WriteMainConfig(this._repository);

  final IMainConfigRepository _repository;

  Future<MainConfig> call({
    required String greenhouseName,
    required String location,
    String? description,
  }) =>
      _repository.create(
        greenhouseName: greenhouseName,
        location: location,
        description: description,
      );
}
