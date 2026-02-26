part of 'collections_api_dto.dart';

@JsonSerializable()
class DiscoverResponseDto {
  const DiscoverResponseDto({
    this.serverUrl,
    this.tokenLabel,
    this.collections,
    this.places,
    this.locationAvailable,
  });

  factory DiscoverResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoverResponseDtoFromJson(json);

  final String? serverUrl;
  final String? tokenLabel;
  final List<CollectionDto>? collections;
  final List<PlaceDto>? places;
  final bool? locationAvailable;

  Map<String, dynamic> toJson() => _$DiscoverResponseDtoToJson(this);
}
