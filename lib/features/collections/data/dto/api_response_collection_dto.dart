part of 'collections_api_dto.dart';

@JsonSerializable()
class ApiResponseCollectionDto {
  const ApiResponseCollectionDto({this.message, this.data});

  factory ApiResponseCollectionDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseCollectionDtoFromJson(json);

  final String? message;
  final CollectionDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseCollectionDtoToJson(this);
}
