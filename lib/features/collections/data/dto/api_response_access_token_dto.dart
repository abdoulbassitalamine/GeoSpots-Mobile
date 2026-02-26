part of 'collections_api_dto.dart';

@JsonSerializable()
class ApiResponseAccessTokenDto {
  const ApiResponseAccessTokenDto({this.message, this.data});

  factory ApiResponseAccessTokenDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseAccessTokenDtoFromJson(json);

  final String? message;
  final AccessTokenDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseAccessTokenDtoToJson(this);
}
