import 'package:college_management_saas/Assignments/data/data_sources/assignment_remote_datasource.dart';
import 'package:college_management_saas/Assignments/domain/assignment_entity.dart';
import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AssignmentRepository {
  Future<Either<Failure, AssignmentPage>> getAssignments({
    AssignmentListQuery query,
  });

  Future<Either<Failure, AssignmentEntity>> getAssignment(String id);

  Future<Either<Failure, AssignmentEntity>> createAssignment(
      CreateAssignmentParams params,
      );

  Future<Either<Failure, AssignmentEntity>> updateAssignment(
      String id,
      UpdateAssignmentParams params,
      );

  Future<Either<Failure, AssignmentSubmissionEntity>> submitAssignment(
      String assignmentId,
      SubmitAssignmentParams params,
      );

  Future<Either<Failure, AssignmentSubmissionEntity?>> getMySubmission(
      String assignmentId,
      );

  Future<Either<Failure, List<AssignmentSubmissionEntity>>> getSubmissions(
      String assignmentId,
      );

  Future<Either<Failure, AssignmentSubmissionEntity>> gradeSubmission(
      String assignmentId,
      String submissionId,
      GradeSubmissionParams params,
      );
}

class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentRemoteDataSource _remote;

  AssignmentRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, AssignmentPage>> getAssignments({
    AssignmentListQuery query = const AssignmentListQuery(),
  }) {
    return _guard(() => _remote.getAssignments(query));
  }

  @override
  Future<Either<Failure, AssignmentEntity>> getAssignment(String id) {
    return _guard(() => _remote.getAssignment(id));
  }

  @override
  Future<Either<Failure, AssignmentEntity>> createAssignment(
      CreateAssignmentParams params,
      ) {
    return _guard(() => _remote.createAssignment(params));
  }

  @override
  Future<Either<Failure, AssignmentEntity>> updateAssignment(
      String id,
      UpdateAssignmentParams params,
      ) {
    return _guard(() => _remote.updateAssignment(id, params));
  }

  @override
  Future<Either<Failure, AssignmentSubmissionEntity>> submitAssignment(
      String assignmentId,
      SubmitAssignmentParams params,
      ) {
    return _guard(() => _remote.submitAssignment(assignmentId, params));
  }

  @override
  Future<Either<Failure, AssignmentSubmissionEntity?>> getMySubmission(
      String assignmentId,
      ) {
    return _guard(() => _remote.getMySubmission(assignmentId));
  }

  @override
  Future<Either<Failure, List<AssignmentSubmissionEntity>>> getSubmissions(
      String assignmentId,
      ) {
    return _guard(() => _remote.getSubmissions(assignmentId));
  }

  @override
  Future<Either<Failure, AssignmentSubmissionEntity>> gradeSubmission(
      String assignmentId,
      String submissionId,
      GradeSubmissionParams params,
      ) {
    return _guard(
          () => _remote.gradeSubmission(assignmentId, submissionId, params),
    );
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Right(await request());
    } on DioException catch (e) {
      return Left(_mapDioFailure(e));
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapDioFailure(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = _readMessage(e.response?.data);

    if (statusCode == 401) {
      return UnauthorizedFailure(message ?? 'Session expired');
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkFailure(message ?? 'Please check your internet connection');
    }

    return ServerFailure(message ?? 'Something went wrong');
  }

  String? _readMessage(dynamic data) {
    if (data is Map) {
      final error = data['error'];
      final message = data['message'];
      if (error != null) return error.toString();
      if (message != null) return message.toString();
    }

    return null;
  }
}