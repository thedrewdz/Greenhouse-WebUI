import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

/// Composition root.
///
/// Classes are annotated with @injectable / @singleton / @lazySingleton and
/// registered automatically by the generated [di.config.dart].
///
/// Rules:
/// - Call [configureDependencies] once in main() before runApp.
/// - Never call [sl] outside this file or BlocProvider widget-tree wiring.
/// - Never reference [sl] from domain code, repositories, or blocs.
final GetIt sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => sl.init();

