import 'package:json_annotation/json_annotation.dart';

part 'place_commands_dto.g.dart';

@JsonSerializable()
class PlaceUpsertRequestDto {
  const PlaceUpsertRequestDto({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.tags = const <String>[],
  });

  factory PlaceUpsertRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PlaceUpsertRequestDtoFromJson(json);

  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final List<String> tags;

  Map<String, dynamic> toJson() => _$PlaceUpsertRequestDtoToJson(this);
}

@JsonSerializable()
class ShareTokenRequestDto {
  const ShareTokenRequestDto({
    required this.permission,
    this.expiresAt,
    this.label,
  });

  factory ShareTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ShareTokenRequestDtoFromJson(json);

  final String permission;
  final DateTime? expiresAt;
  final String? label;

  Map<String, dynamic> toJson() => _$ShareTokenRequestDtoToJson(this);
}

@JsonSerializable()
class ApiResponseShareResponseDto {
  const ApiResponseShareResponseDto({this.message, this.data});

  factory ApiResponseShareResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseShareResponseDtoFromJson(json);

  final String? message;
  final ShareResponseDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseShareResponseDtoToJson(this);
}

@JsonSerializable()
class ShareResponseDto {
  const ShareResponseDto({
    this.token,
    this.url,
    this.permission,
    this.resourceType,
    this.resourceId,
    this.expiresAt,
  });

  factory ShareResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ShareResponseDtoFromJson(json);

  final String? token;
  final String? url;
  final String? permission;
  final String? resourceType;
  final int? resourceId;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => _$ShareResponseDtoToJson(this);
}
