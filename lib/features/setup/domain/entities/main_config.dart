import 'package:equatable/equatable.dart';

/// Domain entity for greenhouse configuration.
///
/// Pure Dart — no Flutter, no Dio, no DTO types.
class MainConfig extends Equatable {
  const MainConfig({
    required this.greenhouseName,
    required this.location,
    this.description,
  });

  final String greenhouseName;
  final String location;
  final String? description;

  @override
  List<Object?> get props => [greenhouseName, location, description];
}
