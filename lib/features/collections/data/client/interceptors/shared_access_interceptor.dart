import 'package:dio/dio.dart';
import 'package:geo_spots/features/collections/presentation/view_model/shared_access_session.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kSharedTokenHeader = 'X-Shared-Token';

class SharedAccessInterceptor extends Interceptor {
  SharedAccessInterceptor({required Ref ref}) : _ref = ref;

  final Ref _ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final activeToken = _ref.read(activeSharedAccessTokenProvider);
    final isSharedEndpoint = options.path.contains('/shared/');

    if (isSharedEndpoint && activeToken != null && activeToken.isNotEmpty) {
      options.headers[_kSharedTokenHeader] = activeToken;
    }

    super.onRequest(options, handler);
  }
}
