enum ShareResourceType {
  place('PLACE'),
  collection('COLLECTION'),
  currentLocation('CURRENT_LOCATION');

  const ShareResourceType(this.backendValue);

  final String backendValue;

  String get normalizedValue => backendValue.toLowerCase();

  static ShareResourceType fromRaw(String? raw) {
    final candidate = (raw ?? '').trim().toUpperCase();
    for (final value in ShareResourceType.values) {
      if (value.backendValue == candidate) {
        return value;
      }
    }
    return ShareResourceType.collection;
  }
}
