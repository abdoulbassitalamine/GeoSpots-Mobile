part of 'collections_api_dto.dart';

@JsonSerializable()
class ImportResultDto {
  const ImportResultDto({
    this.imported,
    this.skipped,
    this.errors,
    this.places,
  });

  factory ImportResultDto.fromJson(Map<String, dynamic> json) =>
      _$ImportResultDtoFromJson(json);

  final int? imported;
  final int? skipped;
  final List<String>? errors;
  final List<PlaceDto>? places;

  Map<String, dynamic> toJson() => _$ImportResultDtoToJson(this);
}
