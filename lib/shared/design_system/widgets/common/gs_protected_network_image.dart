import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/collections/presentation/view_model/shared_access_session.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kAuthorizationHeader = 'Authorization';
const _kSharedTokenQueryParam = 'token';

final _authUserTokenProvider = FutureProvider.autoDispose<String?>((ref) async {
  final result = await ref
      .read(authenticationLocalDatasourceProvider)
      .getAuthUserToken();

  return switch (result) {
    Ok(value: final token) when token != null && token.trim().isNotEmpty =>
      token.trim(),
    _ => null,
  };
});

bool gsIsRemoteImageSource(String value) {
  final normalized = value.trim().toLowerCase();
  if (normalized.isEmpty) {
    return false;
  }

  return normalized.startsWith('http://') ||
      normalized.startsWith('https://') ||
      normalized.startsWith('/api/') ||
      normalized.startsWith('api/');
}

String gsResolveRemoteImageUrl(String imageUrl) {
  final normalized = imageUrl.trim();
  if (!gsIsRemoteImageSource(normalized)) {
    return normalized;
  }

  final lower = normalized.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    return normalized;
  }

  final baseUrl = dotenv.env['API_BASE_URL']?.trim();
  if (baseUrl == null || baseUrl.isEmpty) {
    return normalized;
  }

  final baseUri = Uri.tryParse(baseUrl);
  final imageUri = Uri.tryParse(normalized);
  if (baseUri == null || imageUri == null) {
    return normalized;
  }

  return baseUri.resolveUri(imageUri).toString();
}

Future<void> gsEvictProtectedImage(
  Ref ref,
  String? imageUrl, {
  bool useSharedTokenQueryParam = false,
  String? sharedToken,
}) async {
  final normalizedUrl = imageUrl?.trim();
  if (normalizedUrl == null || normalizedUrl.isEmpty) {
    return;
  }

  final resolvedUrl = gsResolveRemoteImageUrl(normalizedUrl);

  if (useSharedTokenQueryParam) {
    final activeSharedToken = ref.read(activeSharedAccessTokenProvider);
    final effectiveToken = sharedToken ?? activeSharedToken;
    final urlWithToken = _appendSharedTokenToUrl(resolvedUrl, effectiveToken);
    await NetworkImage(urlWithToken).evict();
    return;
  }

  final tokenResult = await ref
      .read(authenticationLocalDatasourceProvider)
      .getAuthUserToken();
  final token = switch (tokenResult) {
    Ok(value: final value) when value != null && value.trim().isNotEmpty =>
      value.trim(),
    _ => null,
  };

  await NetworkImage(
    resolvedUrl,
    headers: token == null
        ? null
        : <String, String>{_kAuthorizationHeader: 'Bearer $token'},
  ).evict();
}

String _appendSharedTokenToUrl(String url, String? token) {
  final normalizedToken = token?.trim();
  if (normalizedToken == null || normalizedToken.isEmpty) {
    return url;
  }

  final uri = Uri.tryParse(url);
  if (uri == null) {
    return url;
  }

  final queryParameters = Map<String, String>.from(uri.queryParameters);
  queryParameters[_kSharedTokenQueryParam] = normalizedToken;

  return uri.replace(queryParameters: queryParameters).toString();
}

class GSProtectedNetworkImage extends ConsumerWidget {
  const GSProtectedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorBuilder,
    this.useSharedTokenQueryParam = false,
    this.sharedToken,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final bool useSharedTokenQueryParam;
  final String? sharedToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final normalizedUrl = imageUrl.trim();
    if (normalizedUrl.isEmpty) {
      return _buildPlaceholder();
    }

    final resolvedUrl = gsResolveRemoteImageUrl(normalizedUrl);

    if (useSharedTokenQueryParam) {
      final activeSharedToken = ref.watch(activeSharedAccessTokenProvider);
      final urlWithToken = _appendSharedTokenToUrl(
        resolvedUrl,
        sharedToken ?? activeSharedToken,
      );

      return _buildImage(
        urlWithToken,
        errorBuilder: errorBuilder ?? (_, _, _) => _buildPlaceholder(),
      );
    }

    final tokenAsync = ref.watch(_authUserTokenProvider);
    return tokenAsync.when(
      data: (token) => _buildImage(
        resolvedUrl,
        headers: token == null
            ? null
            : <String, String>{_kAuthorizationHeader: 'Bearer $token'},
        errorBuilder: errorBuilder ?? (_, _, _) => _buildPlaceholder(),
      ),
      loading: _buildPlaceholder,
      error: (_, _) => _buildImage(
        resolvedUrl,
        errorBuilder: errorBuilder ?? (_, _, _) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildImage(
    String url, {
    Map<String, String>? headers,
    ImageErrorWidgetBuilder? errorBuilder,
  }) {
    return Image.network(
      url,
      headers: headers,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
    );
  }

  Widget _buildPlaceholder() {
    return placeholder ?? const SizedBox.shrink();
  }
}
