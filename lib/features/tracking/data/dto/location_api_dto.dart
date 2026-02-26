import 'package:json_annotation/json_annotation.dart';

part 'location_api_dto.g.dart';

@JsonSerializable()
class UpdateLocationRequestDto {
  const UpdateLocationRequestDto({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.timestamp,
  });

  factory UpdateLocationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateLocationRequestDtoFromJson(json);

  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime? timestamp;

  Map<String, dynamic> toJson() => _$UpdateLocationRequestDtoToJson(this);
}

@JsonSerializable()
class ApiResponseCurrentLocationDto {
  const ApiResponseCurrentLocationDto({this.message, this.data});

  factory ApiResponseCurrentLocationDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseCurrentLocationDtoFromJson(json);

  final String? message;
  final CurrentLocationDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseCurrentLocationDtoToJson(this);
}

@JsonSerializable()
class CurrentLocationDto {
  const CurrentLocationDto({
    this.id,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.timestamp,
    this.isShared,
    this.updatedAt,
  });

  factory CurrentLocationDto.fromJson(Map<String, dynamic> json) =>
      _$CurrentLocationDtoFromJson(json);

  final int? id;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final DateTime? timestamp;
  final bool? isShared;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$CurrentLocationDtoToJson(this);
}

@JsonSerializable()
class ApiResponseShareLocationResponseDto {
  const ApiResponseShareLocationResponseDto({this.message, this.data});

  factory ApiResponseShareLocationResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ApiResponseShareLocationResponseDtoFromJson(json);

  final String? message;
  final ShareLocationResponseDto? data;

  Map<String, dynamic> toJson() =>
      _$ApiResponseShareLocationResponseDtoToJson(this);
}

@JsonSerializable()
class ShareLocationResponseDto {
  const ShareLocationResponseDto({this.token, this.url, this.expiresAt});

  factory ShareLocationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ShareLocationResponseDtoFromJson(json);

  final String? token;
  final String? url;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => _$ShareLocationResponseDtoToJson(this);
}

@JsonSerializable()
class ApiResponsePublicLocationDto {
  const ApiResponsePublicLocationDto({this.message, this.data});

  factory ApiResponsePublicLocationDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponsePublicLocationDtoFromJson(json);

  final String? message;
  final PublicLocationDto? data;

  Map<String, dynamic> toJson() => _$ApiResponsePublicLocationDtoToJson(this);
}

@JsonSerializable()
class PublicLocationDto {
  const PublicLocationDto({
    this.latitude,
    this.longitude,
    this.accuracy,
    this.timestamp,
    this.updatedAt,
    this.ageSeconds,
  });

  factory PublicLocationDto.fromJson(Map<String, dynamic> json) =>
      _$PublicLocationDtoFromJson(json);

  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final DateTime? timestamp;
  final DateTime? updatedAt;
  final int? ageSeconds;

  Map<String, dynamic> toJson() => _$PublicLocationDtoToJson(this);
}
