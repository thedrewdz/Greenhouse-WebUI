import '../entities/main_config.dart';
import '../repositories/i_main_config_repository.dart';

/// Reads the current MainConfig from the services daemon.
///
/// Returns null when setup has not been completed.
class ReadMainConfig {
  const ReadMainConfig(this._repository);

  final IMainConfigRepository _repository;

  Future<MainConfig?> call() => _repository.get();
}
