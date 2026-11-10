import 'package:flutter/foundation.dart';

/// Whether the app is showing saved data because the network failed.
///
/// [OfflineCacheInterceptor] sets it to `true` when it answers a request from
/// the cache, and back to `false` on the next response that comes from the
/// network. The app shows an `OfflineBanner` while it is `true`.
class OfflineStatus extends ValueNotifier<bool> {
  OfflineStatus() : super(false);

  bool get isShowingSavedData => value;
}
