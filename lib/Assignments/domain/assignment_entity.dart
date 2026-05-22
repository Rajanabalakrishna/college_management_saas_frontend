enum AssignmentStatus { draft, published, closed }

AssignmentStatus assignmentStatusFromApi(String? value) {
  switch (value?.toUpperCase()) {
    case 'PUBLISHED':
      return AssignmentStatus.published;
    case 'CLOSED':
      return AssignmentStatus.closed;
    case 'DRAFT':
    default:
      return AssignmentStatus.draft;
  }
}

extension AssignmentStatusX on AssignmentStatus {
  String get apiValue {
    switch (this) {
      case AssignmentStatus.draft:
        return 'DRAFT';
      case AssignmentStatus.published:
        return 'PUBLISHED';
      case AssignmentStatus.closed:
        return 'CLOSED';
    }
  }
}

enum SubmissionStatus { submitted, graded }

SubmissionStatus submissionStatusFromApi(String? value) {
  switch (value?.toUpperCase()) {
    case 'GRADED':
      return SubmissionStatus.graded;
    case 'SUBMITTED':
    default:
      return SubmissionStatus.submitted;
  }
}

extension SubmissionStatusX on SubmissionStatus {
  String get apiValue {
    switch (this) {
      case SubmissionStatus.submitted:
        return 'SUBMITTED';
      case SubmissionStatus.graded:
        return 'GRADED';
    }
  }
}

class AssignmentEntity {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String className;
  final String? section;
  final String? branch;
  final int? year;
  final DateTime dueDate;
  final int maxMarks;
  final AssignmentStatus status;
  final String? fileUrl;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int submissionsCount;
  final AssignmentSubmissionEntity? mySubmission;

  const AssignmentEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.className,
    this.section,
    this.branch,
    this.year,
    required this.dueDate,
    required this.maxMarks,
    required this.status,
    this.fileUrl,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.submissionsCount = 0,
    this.mySubmission,
  });

  bool get isDraft => status == AssignmentStatus.draft;
  bool get isPublished => status == AssignmentStatus.published;
  bool get isClosed => status == AssignmentStatus.closed;
  bool get isOverdue => DateTime.now().isAfter(dueDate);
  bool get canSubmit => isPublished && !isOverdue && mySubmission == null;
}

class AssignmentSubmissionEntity {
  final String id;
  final String assignmentId;
  final String studentId;
  final String? studentName;
  final String? rollNo;
  final String? answerText;
  final String? fileUrl;
  final int? marksObtained;
  final String? feedback;
  final SubmissionStatus status;
  final DateTime submittedAt;
  final DateTime? gradedAt;
  final String? gradedBy;

  const AssignmentSubmissionEntity({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    this.studentName,
    this.rollNo,
    this.answerText,
    this.fileUrl,
    this.marksObtained,
    this.feedback,
    required this.status,
    required this.submittedAt,
    this.gradedAt,
    this.gradedBy,
  });

  bool get isGraded => status == SubmissionStatus.graded;
}

class AssignmentPage {
  final List<AssignmentEntity> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const AssignmentPage({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasNext => page < totalPages;

  AssignmentPage copyWith({
    List<AssignmentEntity>? items,
    int? page,
    int? limit,
    int? total,
    int? totalPages,
  }) {
    return AssignmentPage(
      items: items ?? this.items,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class AssignmentListQuery {
  final int page;
  final int limit;
  final AssignmentStatus? status;
  final String? subject;
  final String? className;
  final String? branch;
  final int? year;

  const AssignmentListQuery({
    this.page = 1,
    this.limit = 10,
    this.status,
    this.subject,
    this.className,
    this.branch,
    this.year,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      'status': status?.apiValue,
      'subject': subject,
      'class_name': className,
      'branch': branch,
      'year': year,
    };

    params.removeWhere((_, value) => value == null || value == '');
    return params;
  }

  AssignmentListQuery copyWith({
    int? page,
    int? limit,
    AssignmentStatus? status,
    String? subject,
    String? className,
    String? branch,
    int? year,
  }) {
    return AssignmentListQuery(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      status: status ?? this.status,
      subject: subject ?? this.subject,
      className: className ?? this.className,
      branch: branch ?? this.branch,
      year: year ?? this.year,
    );
  }
}

class CreateAssignmentParams {
  final String title;
  final String description;
  final String subject;
  final String className;
  final String? section;
  final String? branch;
  final int? year;
  final DateTime dueDate;
  final int maxMarks;
  final AssignmentStatus status;
  final String? fileUrl;

  const CreateAssignmentParams({
    required this.title,
    required this.description,
    required this.subject,
    required this.className,
    this.section,
    this.branch,
    this.year,
    required this.dueDate,
    this.maxMarks = 100,
    this.status = AssignmentStatus.draft,
    this.fileUrl,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'subject': subject,
    'class_name': className,
    'section': section,
    'branch': branch,
    'year': year,
    'due_date': dueDate.toIso8601String(),
    'max_marks': maxMarks,
    'status': status.apiValue,
    'file_url': fileUrl,
  };
}

class UpdateAssignmentParams {
  final String? title;
  final String? description;
  final String? subject;
  final String? className;
  final String? section;
  final String? branch;
  final int? year;
  final DateTime? dueDate;
  final int? maxMarks;
  final AssignmentStatus? status;
  final String? fileUrl;

  const UpdateAssignmentParams({
    this.title,
    this.description,
    this.subject,
    this.className,
    this.section,
    this.branch,
    this.year,
    this.dueDate,
    this.maxMarks,
    this.status,
    this.fileUrl,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'description': description,
      'subject': subject,
      'class_name': className,
      'section': section,
      'branch': branch,
      'year': year,
      'due_date': dueDate?.toIso8601String(),
      'max_marks': maxMarks,
      'status': status?.apiValue,
      'file_url': fileUrl,
    };

    json.removeWhere((_, value) => value == null);
    return json;
  }
}

class SubmitAssignmentParams {
  final String? answerText;
  final String? fileUrl;

  const SubmitAssignmentParams({
    this.answerText,
    this.fileUrl,
  });

  Map<String, dynamic> toJson() => {
    'answer_text': answerText,
    'file_url': fileUrl,
  };
}

class GradeSubmissionParams {
  final int marksObtained;
  final String? feedback;

  const GradeSubmissionParams({
    required this.marksObtained,
    this.feedback,
  });

  Map<String, dynamic> toJson() => {
    'marks_obtained': marksObtained,
    'feedback': feedback,
  };
}