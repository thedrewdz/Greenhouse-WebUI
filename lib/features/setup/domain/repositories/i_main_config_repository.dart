import '../entities/main_config.dart';

/// Repository abstraction for MainConfig persistence operations.
///
/// Lives in domain — implementations live in data/.
/// Domain and cubits depend on this abstract class, never on the concrete impl.
abstract class IMainConfigRepository {
  Future<MainConfig?> get();
  Future<MainConfig> create({
    required String greenhouseName,
    required String location,
    String? description,
  });
}
