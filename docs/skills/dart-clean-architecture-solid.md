# Skill: Dart CLEAN Architecture and SOLID

## Purpose

Guide agents to structure the Main Unit UI as a CLEAN-architecture Dart/Flutter app with SOLID principles applied idiomatically to Dart.

## Use This Skill When

- Establishing or changing the project layer structure.
- Adding a feature that spans presentation, domain, and data.
- Reviewing code for boundary or dependency-rule violations.

## Do Not Use This Skill When

- The task is services (`/services`) or firmware (`/edge`).

## Layers and the Dependency Rule

Organize by layer (typically per feature):

- `presentation` - widgets and blocs/cubits. Depends on `domain` only.
- `domain` - entities, use cases (interactors), and repository **abstractions**. Depends on nothing outward; pure Dart, no Flutter or transport imports.
- `data` - repository **implementations**, the generated OpenAPI REST client, the push transport, and DTO-to-entity mapping. Depends on `domain` abstractions.

The dependency rule points inward: `presentation` and `data` depend on `domain`; `domain` never imports Flutter, HTTP, or generated client types. Map DTOs to domain entities at the `data` boundary - do not let generated client types leak into `domain` or `presentation`.

## SOLID Applied to Dart

- **SRP** - one reason to change per class: a use case does one thing; a cubit manages one screen's state; a repository owns one aggregate.
- **OCP** - extend via new use cases/implementations against existing abstractions rather than editing stable core logic.
- **LSP** - any implementation of a repository abstraction must honor its contract (including error/empty semantics).
- **ISP** - prefer several small `abstract class` interfaces over one broad one; widgets and blocs depend only on the use cases they need.
- **DIP** - depend on abstractions, injected via constructors. `domain` defines repository interfaces; `data` implements them.

## Dependency Injection

- Use `injectable` + `get_it`. Annotate classes with `@injectable` (factory), `@singleton`,
  or `@lazySingleton`. Run `dart run build_runner build` to regenerate `lib/app/di.config.dart`.
- `@Injectable(as: IFoo)` registers a concrete class against its abstraction.
- The composition root is `lib/app/di.dart`. The `sl` locator must not be called outside
  `di.dart` or `BlocProvider` widget-tree wiring.
- Never reference the locator from `domain` code, repositories, or blocs — dependencies
  are injected via constructors, which injectable resolves from annotations.

## Quality Gate

- `domain` has no Flutter, HTTP, or generated-client imports.
- Repository abstractions live in `domain`; implementations live in `data`.
- DTOs are mapped to entities at the `data` boundary; generated types do not appear in `presentation`.
- Dependencies are constructor-injected; no locator usage inside `domain` or blocs.
- Use cases are unit-testable without Flutter or a real transport.
