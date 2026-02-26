part of 'collections_api_dto.dart';

@JsonSerializable()
class ImportRequestDto {
  const ImportRequestDto({
    required this.content,
    required this.format,
    this.defaultTags,
    this.skipDuplicates,
  });

  factory ImportRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ImportRequestDtoFromJson(json);

  final String content;
  final String format;
  final List<String>? defaultTags;
  final bool? skipDuplicates;

  Map<String, dynamic> toJson() => _$ImportRequestDtoToJson(this);
}
