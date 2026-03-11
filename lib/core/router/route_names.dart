abstract class RouteNames {
  // Main app routes
  static const String map = '/map';
  static const String mapName = 'map';

  static const String collections = '/collections';
  static const String collectionsName = 'collections';
  static const String collectionTagParam = 'collectionTag';
  static const String collectionDetails = 'details/:$collectionTagParam';
  static const String collectionDetailsName = 'collection-details';

  static const String settings = '/settings';
  static const String settingsName = 'settings';

  // Auth routes
  static const String welcome = '/welcome';
  static const String welcomeName = 'welcome';

  static const String signIn = '/sign-in';
  static const String signInName = 'sign-in';

  static const String signUp = '/sign-up';
  static const String signUpName = 'sign-up';

  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordName = 'forgot-password';

  // Tracking routes
  static const String liveLocation = '/live-location/:$liveLocationTokenParam';
  static const String liveLocationName = 'live-location';
  static const String liveLocationTokenParam = 'token';

  // Places routes
  static const String places = '/places';
  static const String placesName = 'places';
  static const String placeDetails = 'place-details';
  static const String placeDetailsName = 'place-details';
  static const String placeIdParam = 'placeId';
  static const String upsertPlace = 'upsert';
  static const String upsertPlaceName = 'upsert-place';
}
