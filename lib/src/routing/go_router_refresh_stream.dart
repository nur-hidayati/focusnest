import 'dart:async';

import 'package:flutter/foundation.dart';

// Used to trigger route changes based on changes in the stream, such as authentication state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) =>
              notifyListeners(), // Notify listeners on each stream event
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
