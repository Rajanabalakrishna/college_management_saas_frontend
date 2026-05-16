import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/auth/auth_repository.dart';

// ── Shared base ───────────────────────────────────────────
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

class NoParams {}

// ── Params ────────────────────────────────────────────────
class LoginParams {
  final String email;
  final String password;
  final String collegeDomain;
  LoginParams({
    required this.email,
    required this.password,
    required this.collegeDomain,
  });
}

class RegisterParams {
  final String email;
  final String password;
  final String fullName;
  final String collegeDomain;
  final String role;
  final String? imageUrl;
  final String? rollNo;
  final String? branch;

  RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.collegeDomain,
    required this.role,
    this.imageUrl,
    this.rollNo,
    this.branch,
  });
}


// ── UseCases ──────────────────────────────────────────────
class GetMeUseCase implements UseCase<User, NoParams> {
  final AuthRepository _repo;
  GetMeUseCase(this._repo);

  @override
  Future<Either<Failure, User>> call(NoParams params) => _repo.getMe();
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  @override
  Future<Either<Failure, User>> call(LoginParams params) =>
      _repo.login(params.email, params.password, params.collegeDomain);
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repo;
  LogoutUseCase(this._repo);

  @override
  Future<Either<Failure, void>> call(NoParams params) => _repo.logout();
}

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository _repo;

  RegisterUseCase(this._repo);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return _repo.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      collegeDomain: params.collegeDomain,
      role: params.role,
      imageUrl: params.imageUrl,
      rollNo: params.rollNo,
      branch: params.branch,
    );
  }
}
