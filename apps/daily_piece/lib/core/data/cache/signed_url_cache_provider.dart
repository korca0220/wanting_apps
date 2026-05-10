import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/piece_repository_impl.dart';

part 'signed_url_cache_provider.g.dart';

@Riverpod(keepAlive: true)
SignedUrlCache signedUrlCache(Ref ref) => SignedUrlCache(ref);

/// In-memory cache of `photoPath → signed URL`. Without this, every screen
/// that renders a private bucket photo issues a fresh signed URL — a fresh
/// URL means a fresh cache key for `Image.network`, which means the same
/// photo gets re-downloaded on every navigation. Keeping the URL stable for
/// its TTL lets Flutter's [ImageCache] do its job.
///
/// keepAlive so the cache survives screen disposal — that's the whole point.
/// In-flight requests are coalesced so a grid mounting many tiles for the
/// same path (rare, but possible after invalidate) doesn't fan out.
class SignedUrlCache {
  SignedUrlCache(this._ref);

  static const Duration _ttl = Duration(hours: 1);
  static const Duration _refreshBefore = Duration(minutes: 5);

  final Ref _ref;

  final Map<String, _Entry> _entries = {};
  final Map<String, Future<String>> _inflight = {};

  Future<String> get(String path) {
    final now = DateTime.now();
    final cached = _entries[path];
    if (cached != null && cached.expiresAt.isAfter(now.add(_refreshBefore))) {
      return Future.value(cached.url);
    }

    final pending = _inflight[path];
    if (pending != null) return pending;

    final future = _fetch(path);
    _inflight[path] = future;

    return future.whenComplete(() => _inflight.remove(path));
  }

  Future<String> _fetch(String path) async {
    final url = await _ref
        .read(pieceRepositoryProvider)
        .signedPhotoUrl(path, expiresInSeconds: _ttl.inSeconds);
    _entries[path] = _Entry(url: url, expiresAt: DateTime.now().add(_ttl));

    return url;
  }

  /// Drop a cached URL — call after deleting/replacing the underlying object
  /// so a stale URL never gets returned.
  void invalidate(String path) {
    _entries.remove(path);
  }
}

class _Entry {
  const _Entry({required this.url, required this.expiresAt});

  final String url;
  final DateTime expiresAt;
}
