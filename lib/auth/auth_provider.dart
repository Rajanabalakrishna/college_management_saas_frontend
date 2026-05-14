import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/auth/authProviders.dart';
import 'package:college_management_saas/auth/auth_usecases.dart';

import 'package:college_management_saas/core/constants/storage_keys.dart';
import 'package:college_management_saas/providers/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial()                  = _Initial;
  const factory AuthState.loading()                  = _Loading;
  const factory AuthState.authenticated(User user)   = _Authenticated;
  const factory AuthState.unauthenticated()          = _Unauthenticated;
  const factory AuthState.error(String message)      = _Error;
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final storage    = ref.read(secureStorageProvider);
    final isLoggedIn = await storage.read(key: StorageKeys.loggedIn);

    if (isLoggedIn != 'true') return const AuthState.unauthenticated();

    final token = await storage.read(key: StorageKeys.accessToken);
    if (token == null) {
      await storage.delete(key: StorageKeys.loggedIn);
      return const AuthState.unauthenticated();
    }

    final result = await ref
        .read(authUseCasesProvider)
        .getMe
        .call(NoParams());

    return result.fold(
          (failure) => const AuthState.unauthenticated(),
          (user)    => AuthState.authenticated(user),
    );
  }

  Future<void> login(String email, String password, String domain) async {
    state = const AsyncValue.data(AuthState.loading());

    final result = await ref.read(authUseCasesProvider).login.call(
      LoginParams(email: email, password: password, collegeDomain: domain),
    );

    final newState = result.fold(
          (f) => AuthState.error(f.message),
          (u) => AuthState.authenticated(u),
    );

    // Write flag only on success — fold is sync so no await needed inside
    if (result.isRight()) {
      await ref.read(secureStorageProvider).write(
        key: StorageKeys.loggedIn,
        value: 'true',
      );
    }

    state = AsyncValue.data(newState);
  }

  Future<void> logout() async {
    state = const AsyncValue.data(AuthState.loading());
    await ref.read(authUseCasesProvider).logout.call(NoParams());
    // deleteAll already called inside repository, but clear flag explicitly
    await ref.read(secureStorageProvider).delete(key: StorageKeys.loggedIn);
    state = const AsyncValue.data(AuthState.unauthenticated());
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);