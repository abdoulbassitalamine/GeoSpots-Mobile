import 'package:json_annotation/json_annotation.dart';

part 'places_response_dto.g.dart';

@JsonSerializable()
class ApiResponsePagePlaceDto {
  const ApiResponsePagePlaceDto({this.message, this.data});

  factory ApiResponsePagePlaceDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponsePagePlaceDtoFromJson(json);

  final String? message;
  final PagePlaceDto? data;

  Map<String, dynamic> toJson() => _$ApiResponsePagePlaceDtoToJson(this);
}

@JsonSerializable()
class ApiResponsePlaceDto {
  const ApiResponsePlaceDto({this.message, this.data});

  factory ApiResponsePlaceDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponsePlaceDtoFromJson(json);

  final String? message;
  final PlaceDto? data;

  Map<String, dynamic> toJson() => _$ApiResponsePlaceDtoToJson(this);
}

@JsonSerializable()
class PagePlaceDto {
  const PagePlaceDto({
    this.totalElements,
    this.totalPages,
    this.size,
    this.content,
    this.number,
    this.numberOfElements,
    this.first,
    this.last,
    this.empty,
  });

  factory PagePlaceDto.fromJson(Map<String, dynamic> json) =>
      _$PagePlaceDtoFromJson(json);

  final int? totalElements;
  final int? totalPages;
  final int? size;
  final List<PlaceDto>? content;
  final int? number;
  final int? numberOfElements;
  final bool? first;
  final bool? last;
  final bool? empty;

  Map<String, dynamic> toJson() => _$PagePlaceDtoToJson(this);
}

@JsonSerializable()
class PlaceDto {
  const PlaceDto({
    this.id,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.tags,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.collectionCount,
  });

  factory PlaceDto.fromJson(Map<String, dynamic> json) =>
      _$PlaceDtoFromJson(json);

  final int? id;
  final String? title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final List<String>? tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? username;
  final int? collectionCount;

  Map<String, dynamic> toJson() => _$PlaceDtoToJson(this);
}
