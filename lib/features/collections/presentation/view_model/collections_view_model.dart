import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:geo_spots/core/utils/exception/http_exception.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/export_format.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import 'package:geo_spots/features/collections/domain/enums/share_resource_type.dart';
import 'package:geo_spots/features/collections/domain/use_cases/collections_use_cases.dart';
import 'package:geo_spots/features/collections/domain/use_cases/export_collection_use_case.dart';
import 'package:geo_spots/features/collections/domain/use_cases/import_collection_use_case.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import 'collections_state.dart';
import 'shared_access_session.dart';

part 'collections_view_model.g.dart';

@riverpod
class CollectionsViewModel extends _$CollectionsViewModel {
  static const _supportedExtensions = <String>['gpx', 'kml', 'geojson', 'json'];

  @override
  CollectionsState build() {
    Future.microtask(_loadCollectionsData);
    return const CollectionsState();
  }

  Future<void> _loadCollectionsData() async {
    final previousTab = state.selectedTab;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final getSharedAccessTokens = ref.read(
        getSharedAccessTokensUseCaseProvider,
      );
      final getSharedCollections = ref.read(
        getSharedCollectionsUseCaseProvider,
      );
      final getOwnedCollections = ref.read(getOwnedCollectionsUseCaseProvider);
      final getOwnedShareTokens = ref.read(getOwnedShareTokensUseCaseProvider);
      final authStatus = ref.read(authGuardProvider);
      final isAuthenticated = authStatus is AuthenticationStatusAuthenticated;

      final sharedTokensResult = await getSharedAccessTokens();
      final sharedCollectionsResult = await getSharedCollections();
      final ownedCollectionsResult = isAuthenticated
          ? await getOwnedCollections()
          : const Ok<List<CollectionEntity>>(<CollectionEntity>[]);
      final ownedShareTokensResult = isAuthenticated
          ? await getOwnedShareTokens()
          : const Ok<List<SharedAccessTokenEntity>>(
              <SharedAccessTokenEntity>[],
            );

      final sharedTokens = _requireOk(sharedTokensResult);
      final sharedCollections = _requireOk(sharedCollectionsResult);

      var effectiveAuthenticated = isAuthenticated;
      var ownedCollections = const <CollectionEntity>[];
      var ownedShareTokens = const <SharedAccessTokenEntity>[];

      if (isAuthenticated) {
        switch (ownedCollectionsResult) {
          case Ok(value: final value):
            ownedCollections = value;
          case Err(error: UnauthorizedException()):
            effectiveAuthenticated = false;
          case Err(error: final error, stackTrace: final stackTrace):
            Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
        }

        switch (ownedShareTokensResult) {
          case Ok(value: final value):
            ownedShareTokens = value;
          case Err(error: UnauthorizedException()):
            effectiveAuthenticated = false;
          case Err(error: final error, stackTrace: final stackTrace):
            Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
        }
      }

      if (!effectiveAuthenticated) {
        ownedCollections = const <CollectionEntity>[];
        ownedShareTokens = const <SharedAccessTokenEntity>[];
      }

      final totalPlaces = ownedCollections.fold<int>(
        0,
        (sum, collection) => sum + collection.placesCount,
      );

      state = state.copyWith(
        ownedCollections: ownedCollections,
        sharedCollections: sharedCollections,
        sharedTokens: sharedTokens,
        ownedShareTokens: ownedShareTokens,
        totalPlaces: totalPlaces,
        selectedTab: effectiveAuthenticated
            ? previousTab
            : CollectionsTab.sharedWithMe,
        isLoading: false,
        error: null,
      );
    } on Exception {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement des collections',
      );
    }
  }

  Future<void> refresh() => _loadCollectionsData();

  Future<void> exportCollection(
    CollectionEntity collection,
    ExportFormat format,
  ) async {
    state = state.copyWith(isExporting: true, error: null);

    final exportResult = await ref
        .read(exportCollectionUseCaseProvider)
        .call(collection, format);
    switch (exportResult) {
      case Ok(value: final content):
        final directory = await getTemporaryDirectory();
        final fileName =
            '${collection.tag}_${DateTime.now().millisecondsSinceEpoch}.${format.extension}';
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsString(content);

        await SharePlus.instance.share(
          ShareParams(
            subject: 'Export collection: ${collection.tag}',
            files: <XFile>[XFile(filePath)],
          ),
        );
        state = state.copyWith(isExporting: false);
      case Err():
        state = state.copyWith(
          isExporting: false,
          error: 'Erreur lors de l\'export',
        );
    }
  }

  Future<void> importCollection() async {
    state = state.copyWith(isImporting: true, error: null);

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

    final format = _detectExportFormat(file.extension);
    if (format == null) {
      state = state.copyWith(
        isImporting: false,
        error: 'Format non supporté. Utilisez uniquement: .gpx, .kml, .geojson',
      );
      return;
    }

    final importResult = await ref
        .read(importCollectionUseCaseProvider)
        .call(filePath: file.path!, format: format);

    switch (importResult) {
      case Ok(value: final value):
        await _loadCollectionsData();

        if (value.errors.isNotEmpty) {
          state = state.copyWith(
            error:
                'Import partiel: ${value.imported} importé(s), ${value.skipped} ignoré(s).',
            isImporting: false,
          );
          return;
        }

        state = state.copyWith(isImporting: false);
      case Err(error: final error):
        state = state.copyWith(
          isImporting: false,
          error: 'Erreur lors de l\'import: $error',
        );
    }
  }

  Future<void> shareCollection(
    CollectionEntity collection,
    ShareAccessRight accessRight,
  ) async {
    final shareCollection = ref.read(shareCollectionUseCaseProvider);
    final getOwnedShareTokens = ref.read(getOwnedShareTokensUseCaseProvider);
    final result = await ref.read(shareCollectionUseCaseProvider)(
      collection: collection,
      rights: accessRight,
    );

    switch (result) {
      case Ok(value: final value):
        await SharePlus.instance.share(
          ShareParams(
            subject: 'Partage collection: ${collection.tag}',
            text:
                'Collection: ${collection.tag}\n'
                'Droits: ${accessRight.label}\n'
                'Lien: ${value.url}\n'
                'Token: ${value.token.token}',
          ),
        );

        final ownedShareTokensResult = await ref.read(
          getOwnedShareTokensUseCaseProvider,
        )();
        switch (ownedShareTokensResult) {
          case Ok(value: final ownedShareTokens):
            state = state.copyWith(
              ownedShareTokens: ownedShareTokens,
              selectedTab: CollectionsTab.sharedByMe,
            );
          case Err():
            state = state.copyWith(
              error: 'Erreur lors du rafraîchissement des tokens',
            );
        }
      case Err(error: final error):
        state = state.copyWith(error: 'Erreur lors du partage: $error');
    }
  }

  Future<bool> importSharedAccess({
    required String baseUrl,
    required String token,
  }) async {
    state = state.copyWith(isImportingSharedAccess: true, error: null);

    final importSharedAccess = ref.read(importSharedAccessUseCaseProvider);
    final getSharedAccessTokens = ref.read(
      getSharedAccessTokensUseCaseProvider,
    );
    final getSharedCollections = ref.read(getSharedCollectionsUseCaseProvider);

    final importResult = await importSharedAccess(
      baseUrl: baseUrl,
      token: token,
    );
    if (importResult is Err) {
      state = state.copyWith(
        isImportingSharedAccess: false,
        error: 'Impossible d\'ajouter cet accès partagé',
      );
      return false;
    }

    final sharedTokensResult = await getSharedAccessTokens();
    final sharedCollectionsResult = await getSharedCollections();
    if (sharedTokensResult is Err || sharedCollectionsResult is Err) {
      state = state.copyWith(
        isImportingSharedAccess: false,
        error: 'Impossible d\'ajouter cet accès partagé',
      );
      return false;
    }

    state = state.copyWith(
      isImportingSharedAccess: false,
      sharedTokens:
          (sharedTokensResult as Ok<List<SharedAccessTokenEntity>>).value,
      sharedCollections:
          (sharedCollectionsResult as Ok<List<CollectionEntity>>).value,
      selectedTab: CollectionsTab.sharedWithMe,
    );
    return true;
  }

  Future<void> revokeSharedAccess(String token) async {
    state = state.copyWith(isRevokingSharedAccess: true, error: null);
    final revokeSharedAccess = ref.read(revokeSharedAccessUseCaseProvider);
    final getSharedAccessTokens = ref.read(
      getSharedAccessTokensUseCaseProvider,
    );
    final getSharedCollections = ref.read(getSharedCollectionsUseCaseProvider);
    final revokeResult = await revokeSharedAccess(token);
    if (revokeResult is Err) {
      state = state.copyWith(
        isRevokingSharedAccess: false,
        error: 'Erreur lors de la révocation',
      );
      return;
    }

    final sharedTokensResult = await getSharedAccessTokens();
    final sharedCollectionsResult = await getSharedCollections();
    if (sharedTokensResult is Err || sharedCollectionsResult is Err) {
      state = state.copyWith(
        isRevokingSharedAccess: false,
        error: 'Erreur lors de la révocation',
      );
      return;
    }

    state = state.copyWith(
      isRevokingSharedAccess: false,
      sharedTokens:
          (sharedTokensResult as Ok<List<SharedAccessTokenEntity>>).value,
      sharedCollections:
          (sharedCollectionsResult as Ok<List<CollectionEntity>>).value,
    );
    if (ref.read(activeSharedAccessTokenProvider) == token) {
      ref.read(activeSharedAccessTokenProvider.notifier).token = null;
    }
  }

  Future<void> revokeOwnedShare(String id) async {
    state = state.copyWith(isRevokingSharedAccess: true, error: null);
    final revokeOwnedShare = ref.read(revokeOwnedShareUseCaseProvider);
    final getOwnedShareTokens = ref.read(getOwnedShareTokensUseCaseProvider);
    final revokeResult = await revokeOwnedShare(id);
    if (revokeResult is Err) {
      state = state.copyWith(
        isRevokingSharedAccess: false,
        error: 'Erreur lors de la révocation',
      );
      return;
    }

    final ownedShareTokensResult = await getOwnedShareTokens();
    switch (ownedShareTokensResult) {
      case Ok(value: final ownedShareTokens):
        state = state.copyWith(
          isRevokingSharedAccess: false,
          ownedShareTokens: ownedShareTokens,
        );
      case Err():
        state = state.copyWith(
          isRevokingSharedAccess: false,
          error: 'Erreur lors de la révocation',
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
    final isSharedCollection = state.sharedCollections.any(
      (shared) => shared.id == collection.id,
    );
    if (!isSharedCollection) {
      ref.read(activeSharedAccessTokenProvider.notifier).token = null;
      ref.read(activeCollectionAccessRightProvider.notifier).right = null;
      return;
    }

    final tokenFromState = _findSharedTokenForCollection(collection.id);
    if (tokenFromState != null) {
      ref.read(activeCollectionAccessRightProvider.notifier).right =
          tokenFromState.rights;
      ref.read(activeSharedAccessTokenProvider.notifier).token =
          tokenFromState.token;
      return;
    }

    final getTokenForResource = ref.read(getTokenForResourceUseCaseProvider);
    final tokenResult = await getTokenForResource(
      resourceType: ShareResourceType.collection,
      resourceId: collection.id,
    );
    switch (tokenResult) {
      case Ok(value: final token):
        ref.read(activeSharedAccessTokenProvider.notifier).token = token?.token;
        ref.read(activeCollectionAccessRightProvider.notifier).right =
            token?.rights;
      case Err():
        ref.read(activeSharedAccessTokenProvider.notifier).token = null;
        ref.read(activeCollectionAccessRightProvider.notifier).right = null;
    }
  }

  ExportFormat? _detectExportFormat(String? extension) {
    final normalized = (extension ?? '').toLowerCase();
    if (!_supportedExtensions.contains(normalized)) {
      return null;
    }
    if (normalized == 'gpx') {
      return ExportFormat.gpx;
    }
    if (normalized == 'kml') {
      return ExportFormat.kml;
    }
    if (normalized == 'geojson' || normalized == 'json') {
      return ExportFormat.geoJSON;
    }
    return null;
  }

  SharedAccessTokenEntity? _findSharedTokenForCollection(String collectionId) {
    for (final token in state.sharedTokens) {
      if (ShareResourceType.fromRaw(token.resourceType) ==
              ShareResourceType.collection &&
          token.resourceId == collectionId) {
        return token;
      }
    }
    return null;
  }

  T _requireOk<T>(Result<T> result) {
    return switch (result) {
      Ok(value: final value) => value,
      Err(error: final error, stackTrace: final stackTrace) =>
        Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current),
    };
  }
}
