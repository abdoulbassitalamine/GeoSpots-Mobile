import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geo_spots/features/collections/domain/repository/collections_repository.dart';
import 'package:geo_spots/features/collections/domain/use_cases/export_collection_use_case.dart';
import 'package:geo_spots/features/collections/domain/use_cases/import_collection_use_case.dart';
import 'package:geo_spots/features/places/domain/repository/places_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entity/collection_entity.dart';
import '../../domain/entity/shared_access_token_entity.dart';
import '../../domain/enums/collection_source.dart';
import '../../domain/enums/export_format.dart';
import '../../domain/enums/share_access_right.dart';
import 'collections_state.dart';
import 'shared_access_session.dart';

part 'collections_view_model.g.dart';

@riverpod
class CollectionsViewModel extends _$CollectionsViewModel {
  static const _supportedExtensions = ['gpx', 'kml', 'geojson', 'json'];

  @override
  CollectionsState build() {
    Future.microtask(_loadDummyData);
    return const CollectionsState();
  }

  Future<void> _loadDummyData() async {
    state = state.copyWith(isLoading: true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final allPlaces = await ref.watch(placesRepositoryProvider).getAllPlaces();
    final ownedCollections = ref
        .read(collectionsRepositoryProvider)
        .getOwnedCollections(allPlaces);
    await _seedOwnedSharesForDemo(ownedCollections);
    await _seedReceivedSharesForDemo();
    final sharedTokens = await ref
        .read(collectionsRepositoryProvider)
        .getSharedAccessTokens();
    final sharedCollections = await ref
        .read(collectionsRepositoryProvider)
        .getSharedCollections();
    final ownedShareTokens = await ref
        .read(collectionsRepositoryProvider)
        .getOwnedShareTokens();

    state = state.copyWith(
      ownedCollections: ownedCollections,
      sharedCollections: sharedCollections,
      sharedTokens: sharedTokens,
      ownedShareTokens: ownedShareTokens,
      allPlaces: allPlaces,
      totalPlaces: allPlaces.length,
      isLoading: false,
    );
  }

  Future<void> refresh() async {
    await _loadDummyData();
  }

  Future<void> exportCollection(
    CollectionEntity collection,
    ExportFormat format,
  ) async {
    try {
      state = state.copyWith(isExporting: true);

      final content = await ref
          .read(exportCollectionUseCaseProvider)
          .call(collection, format);

      final directory = await getTemporaryDirectory();
      final fileName =
          '${collection.tag}_${DateTime.now().millisecondsSinceEpoch}.${format.extension}';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(content);

      final shareParams = ShareParams(
        subject: 'Export collection: ${collection.tag}',
        files: [XFile(filePath)],
      );
      await SharePlus.instance.share(shareParams);

      state = state.copyWith(isExporting: false);
    } on Exception catch (e) {
      state = state.copyWith(
        isExporting: false,
        error: 'Erreur lors de l\'export: $e',
      );
    }
  }

  Future<void> importCollection() async {
    try {
      state = state.copyWith(isImporting: true);

      // On iOS, FileType.custom can hide some valid files (notably .gpx/.kml)
      // depending on provider UTType support, so we fallback to `any` and enforce
      // extension validation ourselves.
      final pickerType = Platform.isIOS ? FileType.any : FileType.custom;
      final result = await FilePicker.platform.pickFiles(
        type: pickerType,
        allowedExtensions: pickerType == FileType.custom
            ? _supportedExtensions
            : null,
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(isImporting: false);
        return;
      }

      final file = result.files.first;
      if (file.path == null) {
        state = state.copyWith(
          isImporting: false,
          error: 'Impossible de lire le fichier',
        );
        return;
      }

      // Déterminer le format
      ExportFormat? format;
      final extension = (file.extension ?? '').toLowerCase();
      if (!_supportedExtensions.contains(extension)) {
        state = state.copyWith(
          isImporting: false,
          error:
              'Format non supporte. Utilisez uniquement: .gpx, .kml, .geojson',
        );
        return;
      }

      final content = await File(file.path!).readAsString();

      if (extension == 'gpx') {
        format = ExportFormat.gpx;
      } else if (extension == 'kml') {
        format = ExportFormat.kml;
      } else if (extension == 'geojson' || extension == 'json') {
        format = ExportFormat.geoJSON;
      }

      if (format == null) {
        state = state.copyWith(
          isImporting: false,
          error: 'Format de fichier non supporté',
        );
        return;
      }

      // Importer
      final importedPlaces = await ref
          .read(importCollectionUseCaseProvider)
          .call(content, format);

      final allPlaces = [...state.allPlaces, ...importedPlaces];
      final collections = ref
          .read(collectionsRepositoryProvider)
          .getOwnedCollections(allPlaces);

      state = state.copyWith(
        ownedCollections: collections,
        allPlaces: allPlaces,
        totalPlaces: allPlaces.length,
        isImporting: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isImporting: false,
        error: 'Erreur lors de l\'import: $e',
      );
    }
  }

  Future<void> shareCollection(
    CollectionEntity collection,
    ShareAccessRight accessRight,
  ) async {
    try {
      final token = _generateShareToken();
      final baseUrl =
          dotenv.env['API_BASE_URL']?.replaceAll(RegExp(r'/$'), '') ??
          'https://api.geospots.app';

      final shareUrl = ref
          .read(collectionsRepositoryProvider)
          .buildSharedUrl(
            baseUrl: baseUrl,
            token: token,
            rights: accessRight,
          );

      final shareParams = ShareParams(
        subject: 'Partage collection: ${collection.tag}',
        text:
            'Collection: ${collection.tag}\n'
            'Droits: ${accessRight.label}\n'
            'Lien: $shareUrl\n'
            'Token: $token',
      );
      await SharePlus.instance.share(shareParams);

      await ref.read(collectionsRepositoryProvider).saveOwnedShareToken(
        SharedAccessTokenEntity(
          token: token,
          baseUrl: baseUrl,
          rights: accessRight,
          resourceType: 'collection',
          resourceId: collection.tag,
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        ),
      );
      final ownedShareTokens = await ref
          .read(collectionsRepositoryProvider)
          .getOwnedShareTokens();
      state = state.copyWith(
        ownedShareTokens: ownedShareTokens,
        selectedTab: CollectionsTab.sharedByMe,
      );
    } on Exception catch (e) {
      state = state.copyWith(error: 'Erreur lors du partage: $e');
    }
  }

  Future<bool> importSharedAccess({
    required String baseUrl,
    required String token,
  }) async {
    try {
      state = state.copyWith(isImportingSharedAccess: true, error: null);
      await ref
          .read(collectionsRepositoryProvider)
          .importSharedAccess(baseUrl: baseUrl, token: token);

      final sharedTokens = await ref
          .read(collectionsRepositoryProvider)
          .getSharedAccessTokens();
      final sharedCollections = await ref
          .read(collectionsRepositoryProvider)
          .getSharedCollections();

      state = state.copyWith(
        isImportingSharedAccess: false,
        sharedTokens: sharedTokens,
        sharedCollections: sharedCollections,
        selectedTab: CollectionsTab.sharedWithMe,
      );
      return true;
    } on Exception catch (e) {
      state = state.copyWith(
        isImportingSharedAccess: false,
        error: 'Impossible d\'ajouter cet accès partagé: $e',
      );
      return false;
    }
  }

  Future<void> revokeSharedAccess(String token) async {
    try {
      state = state.copyWith(isRevokingSharedAccess: true, error: null);
      await ref.read(collectionsRepositoryProvider).revokeSharedAccess(token);
      final sharedTokens = await ref
          .read(collectionsRepositoryProvider)
          .getSharedAccessTokens();
      final sharedCollections = await ref
          .read(collectionsRepositoryProvider)
          .getSharedCollections();

      state = state.copyWith(
        isRevokingSharedAccess: false,
        sharedTokens: sharedTokens,
        sharedCollections: sharedCollections,
      );
      if (ref.read(activeSharedAccessTokenProvider) == token) {
        ref.read(activeSharedAccessTokenProvider.notifier).token = null;
      }
    } on Exception catch (e) {
      state = state.copyWith(
        isRevokingSharedAccess: false,
        error: 'Erreur lors de la révocation: $e',
      );
    }
  }

  Future<void> revokeOwnedShare(String token) async {
    try {
      state = state.copyWith(isRevokingSharedAccess: true, error: null);
      await ref.read(collectionsRepositoryProvider).revokeOwnedShare(token);
      final ownedShareTokens = await ref
          .read(collectionsRepositoryProvider)
          .getOwnedShareTokens();
      state = state.copyWith(
        isRevokingSharedAccess: false,
        ownedShareTokens: ownedShareTokens,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isRevokingSharedAccess: false,
        error: 'Erreur lors de la révocation: $e',
      );
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  void selectTab(CollectionsTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  Future<void> activateSharedCollection(CollectionEntity collection) async {
    if (collection.source != CollectionSource.shared) {
      ref.read(activeSharedAccessTokenProvider.notifier).token = null;
      ref.read(activeCollectionAccessRightProvider.notifier).right = null;
      return;
    }

    ref
        .read(activeCollectionAccessRightProvider.notifier)
        .right = collection.rights;

    if (collection.sharedToken != null && collection.sharedToken!.isNotEmpty) {
      ref
          .read(activeSharedAccessTokenProvider.notifier)
          .token = collection.sharedToken;
      return;
    }

    if (collection.sharedResourceId == null) {
      return;
    }

    final token = await ref.read(collectionsRepositoryProvider).getTokenForResource(
      resourceType: 'collection',
      resourceId: collection.sharedResourceId!,
    );

    ref.read(activeSharedAccessTokenProvider.notifier).token = token?.token;
  }

  String _generateShareToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(24, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  Future<void> _seedOwnedSharesForDemo(List<CollectionEntity> collections) async {
    final repository = ref.read(collectionsRepositoryProvider);
    final existing = await repository.getOwnedShareTokens();
    final sharableCollections = collections.where((collection) => collection.tag != 'all').toList();
    if (existing.isNotEmpty || sharableCollections.isEmpty) {
      return;
    }

    final baseUrl =
        dotenv.env['API_BASE_URL']?.replaceAll(RegExp(r'/$'), '') ??
        'https://api.geospots.app';
    final tags = sharableCollections.map((c) => c.tag).toList();
    final firstTag = tags.first;
    final secondTag = tags.length > 1 ? tags[1] : firstTag;
    final thirdTag = tags.length > 2 ? tags[2] : secondTag;

    final demoTokens = <SharedAccessTokenEntity>[
      SharedAccessTokenEntity(
        token: 'demo_read_${firstTag}_A1',
        baseUrl: baseUrl,
        rights: ShareAccessRight.read,
        resourceType: 'collection',
        resourceId: firstTag,
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      ),
      SharedAccessTokenEntity(
        token: 'demo_write_${firstTag}_B2',
        baseUrl: baseUrl,
        rights: ShareAccessRight.write,
        resourceType: 'collection',
        resourceId: firstTag,
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      ),
      SharedAccessTokenEntity(
        token: 'demo_write_${secondTag}_C3',
        baseUrl: baseUrl,
        rights: ShareAccessRight.write,
        resourceType: 'collection',
        resourceId: secondTag,
        expiresAt: DateTime.now().add(const Duration(days: 21)),
      ),
      SharedAccessTokenEntity(
        token: 'demo_read_${thirdTag}_D4',
        baseUrl: baseUrl,
        rights: ShareAccessRight.read,
        resourceType: 'collection',
        resourceId: thirdTag,
        expiresAt: DateTime.now().add(const Duration(days: 3)),
      ),
    ];

    for (final token in demoTokens) {
      await repository.saveOwnedShareToken(token);
    }
  }

  Future<void> _seedReceivedSharesForDemo() async {
    final repository = ref.read(collectionsRepositoryProvider);
    final existing = await repository.getSharedAccessTokens();
    if (existing.isNotEmpty) {
      return;
    }

    final baseUrl =
        dotenv.env['API_BASE_URL']?.replaceAll(RegExp(r'/$'), '') ??
        'https://api.geospots.app';

    await repository.importSharedAccess(
      baseUrl: baseUrl,
      token: 'demo_received_architecture_000123',
    );
    await repository.importSharedAccess(
      baseUrl: baseUrl,
      token: 'w_demo_received_city-walk_000456',
    );
  }
}
