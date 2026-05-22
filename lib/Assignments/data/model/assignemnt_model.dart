import 'package:college_management_saas/Assignments/domain/assignment_entity.dart';

class AssignmentModel extends AssignmentEntity {
  const AssignmentModel({
    required super.id,
    required super.title,
    required super.description,
    required super.subject,
    required super.className,
    super.section,
    super.branch,
    super.year,
    required super.dueDate,
    required super.maxMarks,
    required super.status,
    super.fileUrl,
    required super.createdBy,
    required super.createdAt,
    super.updatedAt,
    super.submissionsCount,
    super.mySubmission,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    final count = json['_count'];
    final mySubmission = _readMap(json, ['my_submission', 'mySubmission']);

    return AssignmentModel(
      id: _readString(json, ['id']),
      title: _readString(json, ['title']),
      description: _readString(json, ['description']),
      subject: _readString(json, ['subject']),
      className: _readString(json, ['class_name', 'className', 'class']),
      section: _readNullableString(json, ['section', 'sec']),
      branch: _readNullableString(json, ['branch']),
      year: _readNullableInt(json, ['year']),
      dueDate: _readDate(json, ['due_date', 'dueDate']),
      maxMarks: _readInt(json, ['max_marks', 'maxMarks'], defaultValue: 100),
      status: assignmentStatusFromApi(_readNullableString(json, ['status'])),
      fileUrl: _readNullableString(json, ['file_url', 'fileUrl']),
      createdBy: _readString(json, ['created_by', 'createdBy']),
      createdAt: _readDate(json, ['created_at', 'createdAt']),
      updatedAt: _readNullableDate(json, ['updated_at', 'updatedAt']),
      submissionsCount: count is Map
          ? _toInt(count['submissions']) ?? 0
          : _readInt(json, ['submissions_count', 'submissionsCount'], defaultValue: 0),
      mySubmission: mySubmission == null
          ? null
          : AssignmentSubmissionModel.fromJson(mySubmission),
    );
  }
}

class AssignmentSubmissionModel extends AssignmentSubmissionEntity {
  const AssignmentSubmissionModel({
    required super.id,
    required super.assignmentId,
    required super.studentId,
    super.studentName,
    super.rollNo,
    super.answerText,
    super.fileUrl,
    super.marksObtained,
    super.feedback,
    required super.status,
    required super.submittedAt,
    super.gradedAt,
    super.gradedBy,
  });

  factory AssignmentSubmissionModel.fromJson(Map<String, dynamic> json) {
    final student = _readMap(json, ['student']);

    return AssignmentSubmissionModel(
      id: _readString(json, ['id']),
      assignmentId: _readString(json, ['assignment_id', 'assignmentId']),
      studentId: _readString(json, ['student_id', 'studentId']),
      studentName: student == null
          ? _readNullableString(json, ['student_name', 'studentName'])
          : _readNullableString(student, ['full_name', 'fullName', 'name']),
      rollNo: student == null
          ? _readNullableString(json, ['roll_no', 'rollNo'])
          : _readNullableString(student, ['roll_no', 'rollNo']),
      answerText: _readNullableString(json, ['answer_text', 'answerText']),
      fileUrl: _readNullableString(json, ['file_url', 'fileUrl']),
      marksObtained: _readNullableInt(json, ['marks_obtained', 'marksObtained']),
      feedback: _readNullableString(json, ['feedback']),
      status: submissionStatusFromApi(_readNullableString(json, ['status'])),
      submittedAt: _readDate(json, ['submitted_at', 'submittedAt']),
      gradedAt: _readNullableDate(json, ['graded_at', 'gradedAt']),
      gradedBy: _readNullableString(json, ['graded_by', 'gradedBy']),
    );
  }
}

class AssignmentPageModel extends AssignmentPage {
  const AssignmentPageModel({
    required super.items,
    required super.page,
    required super.limit,
    required super.total,
    required super.totalPages,
  });

  factory AssignmentPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final source = data is Map<String, dynamic> ? data : json;
    final rawItems = source['items'] ?? source['assignments'] ?? data;

    final list = rawItems is List
        ? rawItems
        .whereType<Map>()
        .map((item) => AssignmentModel.fromJson(Map<String, dynamic>.from(item)))
        .toList()
        : <AssignmentModel>[];

    final page = _readInt(source, ['page'], defaultValue: 1);
    final limit = _readInt(source, ['limit'], defaultValue: list.length);
    final total = _readInt(source, ['total'], defaultValue: list.length);
    final totalPages = _readInt(
      source,
      ['total_pages', 'totalPages'],
      defaultValue: limit == 0 ? 1 : (total / limit).ceil(),
    );

    return AssignmentPageModel(
      items: list,
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages == 0 ? 1 : totalPages,
    );
  }
}

dynamic _read(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (json.containsKey(key) && json[key] != null) return json[key];
  }
  return null;
}

Map<String, dynamic>? _readMap(Map<String, dynamic> json, List<String> keys) {
  final value = _read(json, keys);
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  return _read(json, keys)?.toString() ?? '';
}

String? _readNullableString(Map<String, dynamic> json, List<String> keys) {
  final value = _read(json, keys);
  return value == null ? null : value.toString();
}

int _readInt(
    Map<String, dynamic> json,
    List<String> keys, {
      required int defaultValue,
    }) {
  return _toInt(_read(json, keys)) ?? defaultValue;
}

int? _readNullableInt(Map<String, dynamic> json, List<String> keys) {
  return _toInt(_read(json, keys));
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime _readDate(Map<String, dynamic> json, List<String> keys) {
  final value = _read(json, keys);
  if (value is DateTime) return value;
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime? _readNullableDate(Map<String, dynamic> json, List<String> keys) {
  final value = _read(json, keys);
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}