// features/auth/domain/usecases/get_me_usecase.dart

import 'package:college_management_saas/auth/User/user_model.dart';
import 'package:college_management_saas/auth/auth_repository.dart';
import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

// Base UseCase contract — every usecase follows this pattern
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {} // For usecases that take no arguments

class GetMeUseCase implements UseCase<User, NoParams> {
  final AuthRepository _repository;

  GetMeUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return _repository.getMe();
  }
}