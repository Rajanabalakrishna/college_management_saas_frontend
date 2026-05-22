import 'package:college_management_saas/Assignments/data/data_sources/assignment_remote_datasource.dart';
import 'package:college_management_saas/Assignments/data/repositories/assignment_repository.dart';
import 'package:college_management_saas/Assignments/domain/assignment_entity.dart';
import 'package:college_management_saas/core/errors/failure.dart';
import 'package:college_management_saas/providers/dio_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assignmentRemoteDataSourceProvider = Provider<AssignmentRemoteDataSource>(
      (ref) => AssignmentRemoteDataSourceImpl(ref.read(dioProvider)),
);

final assignmentRepositoryProvider = Provider<AssignmentRepository>(
      (ref) => AssignmentRepositoryImpl(
    ref.read(assignmentRemoteDataSourceProvider),
  ),
);

final assignmentsProvider =
AsyncNotifierProvider<AssignmentsNotifier, AssignmentPage>(
  AssignmentsNotifier.new,
);

class AssignmentsNotifier extends AsyncNotifier<AssignmentPage> {
  AssignmentListQuery _query = const AssignmentListQuery();

  AssignmentListQuery get query => _query;

  @override
  Future<AssignmentPage> build() {
    return _fetch(_query);
  }

  Future<void> refresh([AssignmentListQuery? query]) async {
    if (query != null) _query = query;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(_query));
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasNext) return;

    final nextQuery = _query.copyWith(page: current.page + 1);
    final result = await ref.read(assignmentRepositoryProvider).getAssignments(
      query: nextQuery,
    );

    result.fold(
          (failure) => state = AsyncValue.error(failure, StackTrace.current),
          (nextPage) {
        _query = nextQuery;
        state = AsyncValue.data(
          current.copyWith(
            items: [...current.items, ...nextPage.items],
            page: nextPage.page,
            limit: nextPage.limit,
            total: nextPage.total,
            totalPages: nextPage.totalPages,
          ),
        );
      },
    );
  }

  Future<Either<Failure, AssignmentEntity>> createAssignment(
      CreateAssignmentParams params,
      ) async {
    final result = await ref.read(assignmentRepositoryProvider).createAssignment(params);

    await result.fold(
          (_) async {},
          (_) async => refresh(_query.copyWith(page: 1)),
    );

    return result;
  }

  Future<Either<Failure, AssignmentEntity>> updateAssignment(
      String id,
      UpdateAssignmentParams params,
      ) async {
    final result = await ref.read(assignmentRepositoryProvider).updateAssignment(id, params);

    await result.fold(
          (_) async {},
          (_) async {
        ref.invalidate(assignmentDetailProvider(id));
        await refresh(_query);
      },
    );

    return result;
  }

  Future<Either<Failure, AssignmentSubmissionEntity>> submitAssignment(
      String assignmentId,
      SubmitAssignmentParams params,
      ) async {
    final result = await ref
        .read(assignmentRepositoryProvider)
        .submitAssignment(assignmentId, params);

    result.fold(
          (_) {},
          (_) {
        ref.invalidate(assignmentDetailProvider(assignmentId));
        ref.invalidate(myAssignmentSubmissionProvider(assignmentId));
      },
    );

    return result;
  }

  Future<Either<Failure, AssignmentSubmissionEntity>> gradeSubmission(
      String assignmentId,
      String submissionId,
      GradeSubmissionParams params,
      ) async {
    final result = await ref.read(assignmentRepositoryProvider).gradeSubmission(
      assignmentId,
      submissionId,
      params,
    );

    result.fold(
          (_) {},
          (_) {
        ref.invalidate(assignmentSubmissionsProvider(assignmentId));
        ref.invalidate(assignmentDetailProvider(assignmentId));
      },
    );

    return result;
  }

  Future<AssignmentPage> _fetch(AssignmentListQuery query) async {
    final result = await ref.read(assignmentRepositoryProvider).getAssignments(
      query: query,
    );

    return result.fold(
          (failure) => throw Exception(failure.message),
          (page) => page,
    );
  }
}

final assignmentDetailProvider =
FutureProvider.family<AssignmentEntity, String>((ref, assignmentId) async {
  final result = await ref
      .read(assignmentRepositoryProvider)
      .getAssignment(assignmentId);

  return result.fold(
        (failure) => throw Exception(failure.message),
        (assignment) => assignment,
  );
});

final myAssignmentSubmissionProvider =
FutureProvider.family<AssignmentSubmissionEntity?, String>(
      (ref, assignmentId) async {
    final result = await ref
        .read(assignmentRepositoryProvider)
        .getMySubmission(assignmentId);

    return result.fold(
          (failure) => throw Exception(failure.message),
          (submission) => submission,
    );
  },
);

final assignmentSubmissionsProvider =
FutureProvider.family<List<AssignmentSubmissionEntity>, String>(
      (ref, assignmentId) async {
    final result = await ref
        .read(assignmentRepositoryProvider)
        .getSubmissions(assignmentId);

    return result.fold(
          (failure) => throw Exception(failure.message),
          (submissions) => submissions,
    );
  },
);