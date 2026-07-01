class WifiStatusDto {
  const WifiStatusDto({required this.isOnline, this.networkName});

  factory WifiStatusDto.fromJson(Map<String, dynamic> json) => WifiStatusDto(
        isOnline: json['isOnline'] as bool,
        networkName: json['networkName'] as String?,
      );

  final bool isOnline;
  final String? networkName;
}

class WifiConnectionResultDto {
  const WifiConnectionResultDto({required this.connected, this.errorMessage});

  factory WifiConnectionResultDto.fromJson(Map<String, dynamic> json) =>
      WifiConnectionResultDto(
        connected: json['connected'] as bool,
        errorMessage: json['errorMessage'] as String?,
      );

  final bool connected;
  final String? errorMessage;
}
