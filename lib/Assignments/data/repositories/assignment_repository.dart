import 'package:college_management_saas/Assignments/data/data_sources/assignment_remote_datasource.dart';
import 'package:college_management_saas/Assignments/domain/assignment_entity.dart';
import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AssignmentRepository {
  Future<Either<Failure, AssignmentPage>> getAssignments(
      AssignmentListQuery query,
      );
}

class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentRemoteDataSource _remote;

  AssignmentRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, AssignmentPage>> getAssignments(
      AssignmentListQuery query,
      ) async {
    try {
      final result = await _remote.getAssignments(query);
      return Right(result);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? data['error']?.toString() ?? data['message']?.toString()
          : null;

      if (e.response?.statusCode == 401) {
        return Left(UnauthorizedFailure(message ?? 'Session expired'));
      }

      return Left(ServerFailure(message ?? 'Unable to load assignments'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}