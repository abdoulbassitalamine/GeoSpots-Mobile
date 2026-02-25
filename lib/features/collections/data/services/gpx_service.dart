import 'package:xml/xml.dart';
import '../../../places/domain/entity/place_entity.dart';
import '../../domain/entity/collection_entity.dart';
import '../../domain/services/export_import_service.dart';

class GPXService implements IExportImportService {
  @override
  String export(CollectionEntity collection) {
    final builder = XmlBuilder();

    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element(
      'gpx',
      nest: () {
        builder.attribute('version', '1.1');
        builder.attribute('creator', 'GeoSpots');
        builder.attribute('xmlns', 'http://www.topografix.com/GPX/1/1');
        builder.attribute(
          'xmlns:xsi',
          'http://www.w3.org/2001/XMLSchema-instance',
        );
        builder.attribute(
          'xsi:schemaLocation',
          'http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd',
        );

        builder.element(
          'metadata',
          nest: () {
            builder.element('name', nest: collection.tag);
            builder.element('desc', nest: 'Collection: ${collection.tag}');
            builder.element('time', nest: DateTime.now().toIso8601String());
          },
        );

        for (final place in collection.places) {
          if (place.hasCoordinates) {
            builder.element(
              'wpt',
              nest: () {
                builder.attribute('lat', place.latitude.toString());
                builder.attribute('lon', place.longitude.toString());

                builder.element('name', nest: place.title);
                builder.element('desc', nest: place.description);

                if (place.city != null) {
                  builder.element('city', nest: place.city);
                }

                if (place.country != null) {
                  builder.element('country', nest: place.country);
                }

                if (place.tags.isNotEmpty) {
                  builder.element(
                    'extensions',
                    nest: () {
                      builder.element(
                        'tags',
                        nest: () {
                          for (final tag in place.tags) {
                            builder.element('tag', nest: tag);
                          }
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        }
      },
    );

    return builder.buildDocument().toXmlString(pretty: true);
  }

  @override
  List<PlaceEntity> import(String gpxContent) {
    final document = XmlDocument.parse(gpxContent);
    final places = <PlaceEntity>[];

    final waypoints = document.findAllElements('wpt');

    for (final wpt in waypoints) {
      final lat = double.tryParse(wpt.getAttribute('lat') ?? '');
      final lon = double.tryParse(wpt.getAttribute('lon') ?? '');

      if (lat == null || lon == null) continue;

      final name =
          wpt.findElements('name').firstOrNull?.innerText ?? 'Sans titre';
      final desc = wpt.findElements('desc').firstOrNull?.innerText ?? '';
      final city = wpt.findElements('city').firstOrNull?.innerText;
      final country = wpt.findElements('country').firstOrNull?.innerText;

      final tags = <String>[];
      final extensions = wpt.findElements('extensions').firstOrNull;
      if (extensions != null) {
        final tagsElement = extensions.findElements('tags').firstOrNull;
        if (tagsElement != null) {
          for (final tag in tagsElement.findElements('tag')) {
            tags.add(tag.innerText);
          }
        }
      }

      places.add(
        PlaceEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: name,
          description: desc,
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
