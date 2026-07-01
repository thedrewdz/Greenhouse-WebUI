// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:greenhouse_ui/core/api/dio_client.dart' as _i369;
import 'package:greenhouse_ui/features/setup/data/clients/main_config_service_client.dart'
    as _i183;
import 'package:greenhouse_ui/features/setup/data/clients/setup_service_client.dart'
    as _i217;
import 'package:greenhouse_ui/features/setup/data/clients/wifi_config_service_client.dart'
    as _i348;
import 'package:greenhouse_ui/features/setup/data/repositories/main_config_repository.dart'
    as _i906;
import 'package:greenhouse_ui/features/setup/domain/repositories/i_main_config_repository.dart'
    as _i880;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i369.DioClient>(() => _i369.DioClient());
    gh.factory<_i183.MainConfigServiceClient>(
        () => _i183.MainConfigServiceClient(gh<_i369.DioClient>()));
    gh.factory<_i217.SetupServiceClient>(
        () => _i217.SetupServiceClient(gh<_i369.DioClient>()));
    gh.factory<_i348.WifiConfigServiceClient>(
        () => _i348.WifiConfigServiceClient(gh<_i369.DioClient>()));
    gh.factory<_i880.IMainConfigRepository>(
        () => _i906.MainConfigRepository(gh<_i183.MainConfigServiceClient>()));
    return this;
  }
}
