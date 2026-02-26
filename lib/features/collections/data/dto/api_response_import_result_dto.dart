part of 'collections_api_dto.dart';

@JsonSerializable()
class ApiResponseImportResultDto {
  const ApiResponseImportResultDto({this.message, this.data});

  factory ApiResponseImportResultDto.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseImportResultDtoFromJson(json);

  final String? message;
  final ImportResultDto? data;

  Map<String, dynamic> toJson() => _$ApiResponseImportResultDtoToJson(this);
}
