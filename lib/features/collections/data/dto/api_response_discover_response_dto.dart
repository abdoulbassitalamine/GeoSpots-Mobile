part of 'collections_api_dto.dart';

@JsonSerializable()
class ApiResponseDiscoverResponseDto {
  const ApiResponseDiscoverResponseDto({this.message, this.data});

  factory ApiResponseDiscoverResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseDiscoverResponseDtoFromJson(json);

  final String? message;
  final DiscoverResponseDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseDiscoverResponseDtoToJson(this);
}
