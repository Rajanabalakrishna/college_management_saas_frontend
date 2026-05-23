import 'package:college_management_saas/Assignments/data/data_sources/assignment_remote_datasource.dart';
import 'package:college_management_saas/Assignments/data/repositories/assignment_repository.dart';
import 'package:college_management_saas/Assignments/domain/assignment_entity.dart';
import 'package:college_management_saas/providers/dio_provider.dart';
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

  Future<void> applyFilters(AssignmentListQuery query) async {
    _query = query.copyWith(page: 1);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(_query));
  }

  Future<void> clearFilters() async {
    _query = const AssignmentListQuery();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(_query));
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(_query));
  }

  Future<void> loadNextPage() async {
    final current = state.when<AssignmentPage?>(
      data: (page) => page,
      loading: () => null,
      error: (_, __) => null,
    );

    if (current == null || !current.hasNext) return;

    final nextQuery = _query.copyWith(page: current.page + 1);
    final result = await ref
        .read(assignmentRepositoryProvider)
        .getAssignments(nextQuery);

    result.fold(
          (failure) => state = AsyncValue.error(failure, StackTrace.current),
          (nextPage) {
        _query = nextQuery;
        state = AsyncValue.data(
          current.copyWith(
            items: [...current.items, ...nextPage.items],
            page: nextPage.page,
            total: nextPage.total,
            totalPages: nextPage.totalPages,
          ),
        );
      },
    );
  }

  Future<AssignmentPage> _fetch(AssignmentListQuery query) async {
    final result = await ref
        .read(assignmentRepositoryProvider)
        .getAssignments(query);

    return result.fold(
          (failure) => throw Exception(failure.message),
          (page) => page,
    );
  }
}