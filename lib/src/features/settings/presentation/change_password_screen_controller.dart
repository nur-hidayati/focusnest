import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_screen_controller.g.dart';

@riverpod
class ChangePasswordScreenController extends _$ChangePasswordScreenController {
  @override
  FutureOr<void> build() {}

  Future<bool> submitNewPassword(String newPassword) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => authRepository.updatePassword(newPassword));
    return state.hasError == false;
  }
}
