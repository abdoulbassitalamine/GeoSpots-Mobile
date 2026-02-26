import 'shared_access_token_entity.dart';

class CollectionShareResultEntity {
  const CollectionShareResultEntity({required this.url, required this.token});

  final String url;
  final SharedAccessTokenEntity token;
}
