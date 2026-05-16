import 'package:college_management_saas/auth/auth_repostiory_impl.dart';
import 'package:college_management_saas/auth/auth_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_management_saas/auth/auth_remote_datasource.dart';
import 'package:college_management_saas/auth/auth_repository.dart';
import 'package:college_management_saas/providers/dio_provider.dart';
import 'package:college_management_saas/providers/secure_storage_provider.dart';

final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) =>
    AuthRemoteDataSourceImpl(ref.read(dioProvider)));

final authRepositoryProvider = Provider<AuthRepository>((ref) =>
    AuthRepositoryImpl(
      ref.read(_authRemoteDataSourceProvider),
      ref.read(secureStorageProvider),
    ));

// Single object with all usecases — no separate provider per usecase
final authUseCasesProvider = Provider<_AuthUseCases>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return _AuthUseCases(
    getMe:  GetMeUseCase(repo),
    login:  LoginUseCase(repo),
    register: RegisterUseCase(repo),
    logout: LogoutUseCase(repo),
  );
});

class _AuthUseCases {
  final GetMeUseCase  getMe;
  final LoginUseCase  login;
  final LogoutUseCase logout;
  final RegisterUseCase register;

  const _AuthUseCases({
    required this.getMe,
    required this.login,
    required this.logout,
    required this.register
  });
}