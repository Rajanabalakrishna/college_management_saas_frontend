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
    super.submissionsCount,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      className: json['class_name']?.toString() ?? '',
      section: json['section'] as String?,
      branch: json['branch'] as String?,
      year: _toInt(json['year']),
      dueDate: DateTime.parse(json['due_date'] as String),
      maxMarks: _toInt(json['max_marks']) ?? 100,
      status: assignmentStatusFromApi(json['status'] as String?),
      fileUrl: json['file_url'] as String?,
      createdBy: json['created_by']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      submissionsCount: _toInt(json['_count']?['submissions']) ?? 0,
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
    final data = json['data'] as Map<String, dynamic>;
    final rawItems = data['items'] as List? ?? [];

    return AssignmentPageModel(
      items: rawItems
          .map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: _toInt(data['page']) ?? 1,
      limit: _toInt(data['limit']) ?? 10,
      total: _toInt(data['total']) ?? 0,
      totalPages: _toInt(data['total_pages']) ?? 1,
    );
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}