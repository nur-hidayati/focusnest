import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_screen_controller.g.dart';

// Controller for handling the password reset screen logic using Riverpod
@riverpod
class ResetPasswordScreenController extends _$ResetPasswordScreenController {
  @override
  FutureOr<void> build() {}

  Future<bool> tryResetPassword(String email) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.resetPassword(email));
    return state.hasError == false;
  }
}
