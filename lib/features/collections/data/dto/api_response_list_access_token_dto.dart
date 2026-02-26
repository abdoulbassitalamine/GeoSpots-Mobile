part of 'collections_api_dto.dart';

@JsonSerializable()
class ApiResponseListAccessTokenDto {
  const ApiResponseListAccessTokenDto({this.message, this.data});

  factory ApiResponseListAccessTokenDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseListAccessTokenDtoFromJson(json);

  final String? message;
  final List<AccessTokenDto>? data;

  Map<String, dynamic> toJson() => _$ApiResponseListAccessTokenDtoToJson(this);
}
