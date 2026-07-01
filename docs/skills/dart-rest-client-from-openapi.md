# Skill: Dart REST Client (Dio + Service Clients)

## Purpose

Guide agents to consume the Main Unit services API from the UI using Dio as the HTTP client,
wrapped in per-controller service clients, behind domain repository abstractions.

## Use This Skill When

- Adding or updating an API call from the UI to the services daemon.
- Adding a new service client that mirrors a new backend controller.
- Implementing a `data`-layer repository that calls the services API.
- Wiring the live-push channel into the app.

## Do Not Use This Skill When

- The task is services-side API design (that is `/services`).
- The task is pure presentation/state (see the bloc and UI packs).

## DioClient — Central Configuration

All HTTP configuration lives in `core/api/dio_client.dart`. Service clients receive a
`DioClient` via constructor injection and call `_client.dio.get(...)`. Never instantiate
`Dio` directly inside a service client.

`DioClient` owns: base URL, connect/receive timeouts, default headers, logging interceptors,
and any future retry or auth interceptors. Changes apply automatically to all service clients.

The base URL defaults to `http://127.0.0.1:5000` (loopback only — see ADR 0001).
Override with the `GREENHOUSE_API_URL` build-time environment variable for integration tests.

## Service Client Pattern

Each backend controller has exactly one corresponding service client in the `data/clients/`
folder of the relevant feature. The naming convention is `{Controller}ServiceClient`.

```
MainConfigController  →  MainConfigServiceClient  (features/setup/data/clients/)
WifiConfigController  →  WifiConfigServiceClient  (features/setup/data/clients/)
SetupController       →  SetupServiceClient       (features/setup/data/clients/)
```

A service client:
- Accepts a `DioClient` in its constructor.
- Exposes one typed method per HTTP verb the controller supports.
- Returns typed DTOs (plain Dart classes with `fromJson`/`toJson`).
- Handles 404 → null where appropriate; re-throws other `DioException` for the repository.
- Never maps DTOs to domain entities — that is the repository's job.

```dart
class MainConfigServiceClient {
  MainConfigServiceClient(DioClient client) : _dio = client.dio;

  final Dio _dio;
  static const _path = '/api/setup/main-config';

  Future<MainConfigDto?> get() async {
    try {
      final r = await _dio.get<Map<String, dynamic>>(_path);
      return MainConfigDto.fromJson(r.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<MainConfigDto> post(MainConfigRequestDto request) async {
    final r = await _dio.post<Map<String, dynamic>>(_path, data: request.toJson());
    return MainConfigDto.fromJson(r.data!);
  }
}
```

## DTOs

DTOs are plain Dart classes with manual `fromJson`/`toJson`. No code generation is used.
DTOs live in `data/dtos/` alongside their service client. They must not appear in `domain`
or `presentation`.

## Repository Layer

Repository implementations (`data/repositories/`) consume service clients and map DTOs to
domain entities. The domain layer defines repository abstractions (`domain/repositories/`);
implementations depend on those abstractions, not vice versa.

```dart
class MainConfigRepository implements IMainConfigRepository {
  const MainConfigRepository(this._client);
  final MainConfigServiceClient _client;

  @override
  Future<MainConfig?> get() async {
    final dto = await _client.get();
    return dto == null ? null : MainConfig(greenhouseName: dto.greenhouseName, ...);
  }
}
```

## Push Channel

- Use the daemon's WebSocket or SSE endpoint for live-push cases.
- Expose the push stream through a `domain` abstraction; map payloads to entities in `data`.
- Reconnect with backoff; on reconnect, re-fetch authoritative state over REST.
- Cancel push subscriptions in the bloc/cubit `close()` method.

## Dependency Injection

`DioClient` is a singleton. Service clients and repositories are factories.
Register them in `app/di.dart` (composition root).

```dart
sl.registerLazySingleton<DioClient>(DioClient.new);
sl.registerFactory(() => MainConfigServiceClient(sl()));
sl.registerFactory<IMainConfigRepository>(() => MainConfigRepository(sl()));
```

## Quality Gate

- `DioClient` is the only place `Dio` is constructed.
- Each backend controller has one corresponding service client.
- DTOs do not appear in `domain` or `presentation`.
- Repository implementations depend on domain abstractions, not service clients directly.
- Daemon-unavailable and error paths are handled and surfaced as typed states.
- Base URL is configurable and defaults to loopback; no TLS for the local link.
