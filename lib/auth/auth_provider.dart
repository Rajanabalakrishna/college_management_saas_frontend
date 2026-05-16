import 'dart:convert';

import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/auth/authProviders.dart';
import 'package:college_management_saas/auth/auth_usecases.dart';
import 'package:college_management_saas/core/constants/storage_keys.dart';
import 'package:college_management_saas/providers/secure_storage_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final storage = ref.read(secureStorageProvider);

    final isLoggedIn = await storage.read(key: StorageKeys.loggedIn);
    final accessToken = await storage.read(key: StorageKeys.accessToken);
    final expiry = await storage.read(key: StorageKeys.accessTokenExpiry);
    final userJson = await storage.read(key: StorageKeys.user);

    if (isLoggedIn != 'true' || accessToken == null || userJson == null) {
      await _printStoredAuthData();
      return const AuthState.unauthenticated();
    }

    final user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);

    await _printStoredAuthData(user: user);

    return AuthState.authenticated(user);
  }

  Future<void> login(String email, String password, String domain) async {
    state = const AsyncValue.data(AuthState.loading());

    final result = await ref.read(authUseCasesProvider).login.call(
      LoginParams(
        email: email,
        password: password,
        collegeDomain: domain,
      ),
    );

    state = await result.fold(
          (failure) async => AsyncValue.data(AuthState.error(failure.message)),
          (user) async {
        await _printStoredAuthData(user: user);
        return AsyncValue.data(AuthState.authenticated(user));
      },
    );
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String collegeDomain,
    required String role,
    String? imageUrl,
    String? rollNo,
    String? branch,
  }) async {
    state = const AsyncValue.data(AuthState.loading());

    final result = await ref.read(authUseCasesProvider).register.call(
      RegisterParams(
        email: email,
        password: password,
        fullName: fullName,
        collegeDomain: collegeDomain,
        role: role,
        imageUrl: imageUrl,
        rollNo: rollNo,
        branch: branch,
      ),
    );

    return result.fold(
          (failure) {
        state = AsyncValue.data(AuthState.error(failure.message));
        return false;
      },
          (_) {
        state = const AsyncValue.data(AuthState.unauthenticated());
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.data(AuthState.loading());

    await ref.read(authUseCasesProvider).logout.call(NoParams());

    state = const AsyncValue.data(AuthState.unauthenticated());
  }

  Future<void> _printStoredAuthData({User? user}) async {
    if (!kDebugMode) return;

    final storage = ref.read(secureStorageProvider);

    final accessToken = await storage.read(key: StorageKeys.accessToken);
    final expiry = await storage.read(key: StorageKeys.accessTokenExpiry);
    final storedUser = await storage.read(key: StorageKeys.user);

    debugPrint('========== AUTH SECURE STORAGE ==========');
    debugPrint('UserProvider user: ${user?.toJson() ?? storedUser}');
    debugPrint('Access token: $accessToken');
    debugPrint('Access token expiry: $expiry');
    debugPrint('=========================================');
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final userProvider = Provider<User?>((ref) {
  final authAsync = ref.watch(authProvider);

  return authAsync.maybeWhen(
    data: (authState) => authState.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    ),
    orElse: () => null,
  );
});