import 'dart:async';

import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_screen_controller.g.dart';

// Controller class for managing sign out logic using Riverpod
@riverpod
class SettingsScreenController extends _$SettingsScreenController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }
  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}
