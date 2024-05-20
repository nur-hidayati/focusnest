import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verify_delete_account_screen_controller.g.dart';

@riverpod
class VerifyDeleteAccountScreenController
    extends _$VerifyDeleteAccountScreenController {
  @override
  FutureOr<void> build() {}

  Future<void> submitDeleteUser() async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.deleteUserAccount());
  }
}
