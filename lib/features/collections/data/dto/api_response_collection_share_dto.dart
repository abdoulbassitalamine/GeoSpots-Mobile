part of 'collections_api_dto.dart';

@JsonSerializable()
class ApiResponseCollectionShareDto {
  const ApiResponseCollectionShareDto({this.message, this.data});

  factory ApiResponseCollectionShareDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseCollectionShareDtoFromJson(json);

  final String? message;
  final CollectionShareResponseDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseCollectionShareDtoToJson(this);
}
