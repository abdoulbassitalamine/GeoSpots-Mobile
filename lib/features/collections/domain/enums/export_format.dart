enum ExportFormat {
  gpx('gpx', 'application/gpx+xml'),
  kml('kml', 'application/vnd.google-earth.kml+xml'),
  geoJSON('geojson', 'application/geo+json');

  const ExportFormat(this.extension, this.mimeType);
  final String extension;
  final String mimeType;
}