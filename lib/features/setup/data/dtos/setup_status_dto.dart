class SetupStatusDto {
  const SetupStatusDto({
    required this.setupComplete,
    required this.isOnline,
    required this.requiredStep,
  });

  factory SetupStatusDto.fromJson(Map<String, dynamic> json) => SetupStatusDto(
        setupComplete: json['setupComplete'] as bool,
        isOnline: json['isOnline'] as bool,
        requiredStep: json['requiredStep'] as String?,
      );

  final bool setupComplete;
  final bool isOnline;

  /// One of: 'network-connection', 'main-config', 'network-recovery', or null.
  final String? requiredStep;
}
