import 'package:college_management_saas/Attendance/data/data_sources/attendance_remote_datasource.dart';
import 'package:college_management_saas/Attendance/data/repositories/attendance_repository.dart';
import 'package:college_management_saas/Attendance/domain/attendance_entity.dart';
import 'package:college_management_saas/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/attendance_repository.dart';

final attendanceRemoteDataSourceProvider = Provider<AttendanceRemoteDataSource>(
      (ref) => AttendanceRemoteDataSourceImpl(ref.read(dioProvider)),
);

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
      (ref) => AttendanceRepositoryImpl(ref.read(attendanceRemoteDataSourceProvider)),
);

final attendanceProvider =
AsyncNotifierProvider<AttendanceNotifier, AttendanceDay>(
  AttendanceNotifier.new,
);

class AttendanceNotifier extends AsyncNotifier<AttendanceDay> {
  AttendanceQuery _query = AttendanceQuery(date: _todayYmd());

  AttendanceQuery get query => _query;

  @override
  Future<AttendanceDay> build() {
    return _fetch(_query);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(_query));
  }

  Future<void> setDate(DateTime date) async {
    _query = _query.copyWith(date: _ymd(date));
    await refresh();
  }

  Future<void> applyFilters({
    String? className,
    String? sec,
    String? branch,
    int? year,
  }) async {
    _query = AttendanceQuery(
      date: _query.date,
      className: _blankToNull(className),
      sec: _blankToNull(sec),
      branch: _blankToNull(branch),
      year: year,
    );
    await refresh();
  }

  Future<void> clearFilters() async {
    _query = _query.copyWith(clearFilters: true);
    await refresh();
  }

  void toggleStudent(String studentId, bool present) {
    final current = state.value;
    if (current == null || !current.editable) return;

    final students = current.students.map((student) {
      if (student.id != studentId) return student;
      return student.copyWith(
        status: present ? AttendanceStatus.present : AttendanceStatus.absent,
      );
    }).toList();

    state = AsyncValue.data(_withStudents(current, students));
  }

  void markAll(AttendanceStatus status) {
    final current = state.value;
    if (current == null || !current.editable) return;

    final students = current.students
        .map((student) => student.copyWith(status: status))
        .toList();

    state = AsyncValue.data(_withStudents(current, students));
  }

  Future<void> saveToday() async {
    final current = state.value;
    if (current == null) return;

    if (!current.editable) {
      throw Exception('Previous attendance is read only');
    }

    final result = await ref
        .read(attendanceRepositoryProvider)
        .saveAttendance(current.date, current.students);

    result.fold(
          (failure) => throw Exception(failure.message),
          (day) => state = AsyncValue.data(day),
    );
  }

  Future<AttendanceDay> _fetch(AttendanceQuery query) async {
    final result = await ref
        .read(attendanceRepositoryProvider)
        .getAttendance(query);

    return result.fold(
          (failure) => throw Exception(failure.message),
          (day) => day,
    );
  }

  AttendanceDay _withStudents(
      AttendanceDay day,
      List<AttendanceStudent> students,
      ) {
    final present = students
        .where((student) => student.status == AttendanceStatus.present)
        .length;

    return day.copyWith(
      students: students,
      total: students.length,
      presentCount: present,
      absentCount: students.length - present,
    );
  }
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

String _todayYmd() => _ymd(DateTime.now());

String _ymd(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}