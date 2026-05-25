import 'package:college_management_saas/Results/domain/result_entity.dart';

class ResultStudentModel extends ResultStudent {
  const ResultStudentModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.rollNo,
    super.className,
    super.sec,
    super.branch,
    super.year,
  });

  factory ResultStudentModel.fromJson(Map<String, dynamic> json) {
    return ResultStudentModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      rollNo: json['roll_no'] as String?,
      className: (json['class'] ?? json['class_name']) as String?,
      sec: json['sec'] as String?,
      branch: json['branch'] as String?,
      year: _toInt(json['year']),
    );
  }
}

class StudentResultModel extends StudentResult {
  const StudentResultModel({
    required super.id,
    required super.studentId,
    required super.subject,
    required super.examType,
    super.semester,
    required super.academicYear,
    required super.maxMarks,
    required super.marksObtained,
    required super.percentage,
    super.grade,
    required super.resultStatus,
    super.remarks,
    required super.createdAt,
    required super.updatedAt,
    super.student,
  });

  factory StudentResultModel.fromJson(Map<String, dynamic> json) {
    final student = json['student'];

    return StudentResultModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      examType: json['exam_type']?.toString() ?? '',
      semester: _toInt(json['semester']),
      academicYear: json['academic_year']?.toString() ?? '',
      maxMarks: _toInt(json['max_marks']) ?? 100,
      marksObtained: _toDouble(json['marks_obtained']),
      percentage: _toDouble(json['percentage']),
      grade: json['grade'] as String?,
      resultStatus: json['result_status']?.toString() ?? 'PASS',
      remarks: json['remarks'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      student: student is Map<String, dynamic>
          ? ResultStudentModel.fromJson(student)
          : null,
    );
  }
}

class ResultSummaryModel extends ResultSummary {
  const ResultSummaryModel({
    required super.totalSubjects,
    required super.totalMarks,
    required super.marksObtained,
    required super.percentage,
    required super.passCount,
    required super.failCount,
    required super.withheldCount,
  });

  factory ResultSummaryModel.fromJson(Map<String, dynamic> json) {
    return ResultSummaryModel(
      totalSubjects: _toInt(json['total_subjects']) ?? 0,
      totalMarks: _toInt(json['total_marks']) ?? 0,
      marksObtained: _toDouble(json['marks_obtained']),
      percentage: _toDouble(json['percentage']),
      passCount: _toInt(json['pass_count']) ?? 0,
      failCount: _toInt(json['fail_count']) ?? 0,
      withheldCount: _toInt(json['withheld_count']) ?? 0,
    );
  }
}

class ResultPageModel extends ResultPage {
  const ResultPageModel({
    required super.items,
    required super.page,
    required super.limit,
    required super.total,
    required super.totalPages,
    required super.summary,
  });

  factory ResultPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final rawItems = data['items'] as List? ?? [];

    return ResultPageModel(
      items: rawItems
          .map((e) => StudentResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: _toInt(data['page']) ?? 1,
      limit: _toInt(data['limit']) ?? 20,
      total: _toInt(data['total']) ?? 0,
      totalPages: _toInt(data['total_pages']) ?? 1,
      summary: ResultSummaryModel.fromJson(
        data['summary'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}