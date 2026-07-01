class MainConfigDto {
  const MainConfigDto({
    required this.greenhouseName,
    required this.location,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MainConfigDto.fromJson(Map<String, dynamic> json) => MainConfigDto(
        greenhouseName: json['greenhouseName'] as String,
        location: json['location'] as String,
        description: json['description'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  final String greenhouseName;
  final String location;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class MainConfigRequestDto {
  const MainConfigRequestDto({
    required this.greenhouseName,
    required this.location,
    this.description,
  });

  final String greenhouseName;
  final String location;
  final String? description;

  Map<String, dynamic> toJson() => {
        'greenhouseName': greenhouseName,
        'location': location,
        if (description != null) 'description': description,
      };
}
