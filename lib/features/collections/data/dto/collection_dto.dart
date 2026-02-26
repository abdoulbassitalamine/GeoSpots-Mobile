part of 'collections_api_dto.dart';

@JsonSerializable()
class CollectionDto {
  const CollectionDto({
    this.id,
    this.name,
    this.tagFilter,
    this.isShared,
    this.createdAt,
    this.placeCount,
    this.email,
  });

  factory CollectionDto.fromJson(Map<String, dynamic> json) =>
      _$CollectionDtoFromJson(json);

  final int? id;
  final String? name;
  final String? tagFilter;
  final bool? isShared;
  final DateTime? createdAt;
  final int? placeCount;
  final String? email;

  Map<String, dynamic> toJson() => _$CollectionDtoToJson(this);
}
