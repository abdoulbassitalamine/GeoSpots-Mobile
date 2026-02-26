import 'package:xml/xml.dart';
import '../../../places/domain/entity/place_entity.dart';
import '../../domain/entity/collection_entity.dart';
import '../../domain/services/export_import_service.dart';

class KMLService implements IExportImportService {
  @override
  String export(CollectionEntity collection, List<PlaceEntity> places) {
    final builder = XmlBuilder();

    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element(
      'kml',
      nest: () {
        builder.attribute('xmlns', 'http://www.opengis.net/kml/2.2');

        builder.element(
          'Document',
          nest: () {
            builder.element('name', nest: collection.tag);
            builder.element(
              'description',
              nest: 'Collection: ${collection.tag}',
            );

            builder.element(
              'Style',
              nest: () {
                builder.attribute('id', 'defaultStyle');
                builder.element(
                  'IconStyle',
                  nest: () {
                    builder.element(
                      'Icon',
                      nest: () {
                        builder.element(
                          'href',
                          nest:
                              'http://maps.google.com/mapfiles/kml/paddle/red-circle.png',
                        );
                      },
                    );
                  },
                );
              },
            );

            for (final place in places) {
              if (place.hasCoordinates) {
                builder.element(
                  'Placemark',
                  nest: () {
                    builder.element('name', nest: place.title);
                    builder.element(
                      'description',
                      nest: _buildDescription(place),
                    );
                    builder.element('styleUrl', nest: '#defaultStyle');

                    if (place.tags.isNotEmpty ||
                        place.city != null ||
                        place.country != null) {
                      builder.element(
                        'ExtendedData',
                        nest: () {
                          if (place.tags.isNotEmpty) {
                            builder.element(
                              'Data',
                              nest: () {
                                builder.attribute('name', 'tags');
                                builder.element(
                                  'value',
                                  nest: place.tags.join(', '),
                                );
                              },
                            );
                          }

                          if (place.city != null) {
                            builder.element(
                              'Data',
                              nest: () {
                                builder.attribute('name', 'city');
                                builder.element('value', nest: place.city);
                              },
                            );
                          }

                          if (place.country != null) {
                            builder.element(
                              'Data',
                              nest: () {
                                builder.attribute('name', 'country');
                                builder.element('value', nest: place.country);
                              },
                            );
                          }
                        },
                      );
                    }

                    builder.element(
                      'Point',
                      nest: () {
                        builder.element(
                          'coordinates',
                          nest: '${place.longitude},${place.latitude},0',
                        );
                      },
                    );
                  },
                );
              }
            }
          },
        );
      },
    );

    return builder.buildDocument().toXmlString(pretty: true);
  }

  String _buildDescription(PlaceEntity place) {
    final parts = <String>[place.description];

    if (place.city != null || place.country != null) {
      final location = [
        place.city,
        place.country,
      ].where((e) => e != null).join(', ');
      parts.add('Location: $location');
    }

    if (place.tags.isNotEmpty) {
      parts.add('Tags: ${place.tags.join(", ")}');
    }

    return parts.join('\n\n');
  }

  @override
  List<PlaceEntity> import(String kmlContent) {
    final document = XmlDocument.parse(kmlContent);
    final places = <PlaceEntity>[];

    final placemarks = document.findAllElements('Placemark');

    for (final placemark in placemarks) {
      final name =
          placemark.findElements('name').firstOrNull?.innerText ?? 'Sans titre';
      final description =
          placemark.findElements('description').firstOrNull?.innerText ?? '';

      final coordinates = placemark
          .findAllElements('coordinates')
          .firstOrNull
          ?.innerText
          .trim();

      if (coordinates == null) continue;

      final coords = coordinates.split(',');
      if (coords.length < 2) continue;

      final lon = double.tryParse(coords[0].trim());
      final lat = double.tryParse(coords[1].trim());

      if (lat == null || lon == null) continue;

      String? city;
      String? country;
      final tags = <String>[];

      final extendedData = placemark.findElements('ExtendedData').firstOrNull;
      if (extendedData != null) {
        for (final data in extendedData.findElements('Data')) {
          final dataName = data.getAttribute('name');
          final value = data.findElements('value').firstOrNull?.innerText;

          if (value != null) {
            if (dataName == 'tags') {
              tags.addAll(value.split(',').map((t) => t.trim()));
            } else if (dataName == 'city') {
              city = value;
            } else if (dataName == 'country') {
              country = value;
            }
          }
        }
      }

      places.add(
        PlaceEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: name,
          description: description,
          tags: tags,
          date: DateTime.now().toString(),
          latitude: lat,
          longitude: lon,
          city: city,
          country: country,
        ),
      );
    }

    return places;
  }
}
