import 'dart:async';

import 'package:focusnest/src/features/authentication/data/auth_repository.dart';
import 'package:focusnest/src/features/authentication/presentation/auth_form_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

// Controller class for managing authentication logic using Riverpod
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<bool> submitAuth({
    required String email,
    required String password,
    required AuthFormType formType,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authenticate(
        email,
        password,
        formType,
      ),
    );
    return state.hasError == false;
  }

  Future<void> _authenticate(
    String email,
    String password,
    AuthFormType formType,
  ) {
    final authRepository = ref.read(authRepositoryProvider);

    switch (formType) {
      case AuthFormType.signIn:
        return authRepository.signInWithEmailAndPassword(email, password);
      case AuthFormType.register:
        return authRepository.createNewUser(email: email, password: password);
    }
  }
}
