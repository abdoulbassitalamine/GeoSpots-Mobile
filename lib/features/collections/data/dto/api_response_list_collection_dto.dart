part of 'collections_api_dto.dart';

@JsonSerializable()
class ApiResponseListCollectionDto {
  const ApiResponseListCollectionDto({this.message, this.data});

  factory ApiResponseListCollectionDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseListCollectionDtoFromJson(json);

  final String? message;
  final List<CollectionDto>? data;

  Map<String, dynamic> toJson() => _$ApiResponseListCollectionDtoToJson(this);
}
