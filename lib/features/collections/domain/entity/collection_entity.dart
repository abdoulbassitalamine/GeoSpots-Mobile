import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_entity.freezed.dart';

@Freezed(fromJson: false)
sealed class CollectionEntity with _$CollectionEntity {
  const factory CollectionEntity({
    required String id,
    required String tag,
    required int placesCount,
  }) = _CollectionEntity;
}
