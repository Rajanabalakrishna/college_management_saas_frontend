enum AssignmentStatus { draft, published, closed }

AssignmentStatus assignmentStatusFromApi(String? value) {
  switch (value?.toUpperCase()) {
    case 'PUBLISHED':
      return AssignmentStatus.published;
    case 'CLOSED':
      return AssignmentStatus.closed;
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

  String get label {
    switch (this) {
      case AssignmentStatus.draft:
        return 'Draft';
      case AssignmentStatus.published:
        return 'Published';
      case AssignmentStatus.closed:
        return 'Closed';
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
  final int submissionsCount;

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
    this.submissionsCount = 0,
  });

  bool get isOverdue => DateTime.now().isAfter(dueDate);
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
    final data = {
      'page': page,
      'limit': limit,
      'status': status?.apiValue,
      'subject': subject,
      'class_name': className,
      'branch': branch,
      'year': year,
    };

    data.removeWhere((_, value) => value == null || value == '');
    return data;
  }

  AssignmentListQuery copyWith({
    int? page,
    int? limit,
    AssignmentStatus? status,
    String? subject,
    String? className,
    String? branch,
    int? year,
    bool clearStatus = false,
  }) {
    return AssignmentListQuery(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      status: clearStatus ? null : status ?? this.status,
      subject: subject ?? this.subject,
      className: className ?? this.className,
      branch: branch ?? this.branch,
      year: year ?? this.year,
    );
  }
}