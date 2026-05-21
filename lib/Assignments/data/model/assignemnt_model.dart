class AssignmentModel {
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
  final String status;      // DRAFT | PUBLISHED | CLOSED
  final String? fileUrl;
  final String createdBy;
  final DateTime createdAt;
  final int? submissionsCount;

  AssignmentModel({
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
    this.submissionsCount,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) => AssignmentModel(
    id:               json['id'],
    title:            json['title'],
    description:      json['description'],
    subject:          json['subject'],
    className:        json['class_name'],
    section:          json['section'],
    branch:           json['branch'],
    year:             json['year'],
    dueDate:          DateTime.parse(json['due_date']),
    maxMarks:         json['max_marks'] ?? 100,
    status:           json['status'],
    fileUrl:          json['file_url'],
    createdBy:        json['created_by'],
    createdAt:        DateTime.parse(json['created_at']),
    submissionsCount: json['_count']?['submissions'],
  );

  bool get isOverdue => DateTime.now().isAfter(dueDate) && status == 'PUBLISHED';
  bool get isDraft   => status == 'DRAFT';
  bool get isPublished => status == 'PUBLISHED';
}