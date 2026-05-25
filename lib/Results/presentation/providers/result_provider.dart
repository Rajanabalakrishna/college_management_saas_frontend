import 'package:college_management_saas/Results/data/data_sources/result_remote_datasource.dart';
import 'package:college_management_saas/Results/data/repositories/result_repository.dart';
import 'package:college_management_saas/Results/domain/result_entity.dart';
import 'package:college_management_saas/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resultRemoteDataSourceProvider = Provider<ResultRemoteDataSource>(
      (ref) => ResultRemoteDataSourceImpl(ref.read(dioProvider)),
);

final resultRepositoryProvider = Provider<ResultRepository>(
      (ref) => ResultRepositoryImpl(ref.read(resultRemoteDataSourceProvider)),
);

final resultsProvider = AsyncNotifierProvider<ResultsNotifier, ResultPage>(
  ResultsNotifier.new,
);

class ResultsNotifier extends AsyncNotifier<ResultPage> {
  ResultQuery _query = const ResultQuery();

  ResultQuery get query => _query;

  @override
  Future<ResultPage> build() {
    return _fetch(_query);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(_query));
  }

  Future<void> setStudentId(String studentId) async {
    _query = ResultQuery(studentId: studentId);
    await refresh();
  }

  Future<void> useLoggedInStudent() async {
    _query = const ResultQuery();
    await refresh();
  }

  Future<void> applyFilters({
    String? subject,
    String? examType,
    int? semester,
    String? academicYear,
  }) async {
    _query = ResultQuery(
      studentId: _query.studentId,
      subject: _blankToNull(subject),
      examType: _blankToNull(examType),
      semester: semester,
      academicYear: _blankToNull(academicYear),
    );

    await refresh();
  }

  Future<void> clearFilters() async {
    _query = ResultQuery(studentId: _query.studentId);
    await refresh();
  }

  Future<void> loadNextPage() async {
    final current = state.when<ResultPage?>(
      data: (page) => page,
      loading: () => null,
      error: (_, __) => null,
    );

    if (current == null || !current.hasNext) return;

    final nextQuery = _query.copyWith(page: current.page + 1);
    final result = await ref.read(resultRepositoryProvider).getResults(nextQuery);

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
            summary: nextPage.summary,
          ),
        );
      },
    );
  }

  Future<ResultPage> _fetch(ResultQuery query) async {
    final result = await ref.read(resultRepositoryProvider).getResults(query);

    return result.fold(
          (failure) => throw Exception(failure.message),
          (page) => page,
    );
  }
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}