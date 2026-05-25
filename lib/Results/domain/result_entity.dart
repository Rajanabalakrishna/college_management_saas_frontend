class StudentResult {
  final String id;
  final String studentId;
  final String subject;
  final String examType;
  final int? semester;
  final String academicYear;
  final int maxMarks;
  final double marksObtained;
  final double percentage;
  final String? grade;
  final String resultStatus;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ResultStudent? student;

  const StudentResult({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.examType,
    this.semester,
    required this.academicYear,
    required this.maxMarks,
    required this.marksObtained,
    required this.percentage,
    this.grade,
    required this.resultStatus,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
    this.student,
  });

  bool get isPass => resultStatus.toUpperCase() == 'PASS';
}

class ResultStudent {
  final String id;
  final String fullName;
  final String email;
  final String? rollNo;
  final String? className;
  final String? sec;
  final String? branch;
  final int? year;

  const ResultStudent({
    required this.id,
    required this.fullName,
    required this.email,
    this.rollNo,
    this.className,
    this.sec,
    this.branch,
    this.year,
  });
}

class ResultSummary {
  final int totalSubjects;
  final int totalMarks;
  final double marksObtained;
  final double percentage;
  final int passCount;
  final int failCount;
  final int withheldCount;

  const ResultSummary({
    required this.totalSubjects,
    required this.totalMarks,
    required this.marksObtained,
    required this.percentage,
    required this.passCount,
    required this.failCount,
    required this.withheldCount,
  });
}

class ResultPage {
  final List<StudentResult> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final ResultSummary summary;

  const ResultPage({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.summary,
  });

  bool get hasNext => page < totalPages;

  ResultPage copyWith({
    List<StudentResult>? items,
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    ResultSummary? summary,
  }) {
    return ResultPage(
      items: items ?? this.items,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      summary: summary ?? this.summary,
    );
  }
}

class ResultQuery {
  final int page;
  final int limit;
  final String? studentId;
  final String? subject;
  final String? examType;
  final int? semester;
  final String? academicYear;

  const ResultQuery({
    this.page = 1,
    this.limit = 20,
    this.studentId,
    this.subject,
    this.examType,
    this.semester,
    this.academicYear,
  });

  Map<String, dynamic> toQueryParameters() {
    final data = {
      'page': page,
      'limit': limit,
      'student_id': studentId,
      'subject': subject,
      'exam_type': examType,
      'semester': semester,
      'academic_year': academicYear,
    };

    data.removeWhere((_, value) => value == null || value == '');
    return data;
  }

  ResultQuery copyWith({
    int? page,
    int? limit,
    String? studentId,
    String? subject,
    String? examType,
    int? semester,
    String? academicYear,
  }) {
    return ResultQuery(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      studentId: studentId ?? this.studentId,
      subject: subject ?? this.subject,
      examType: examType ?? this.examType,
      semester: semester ?? this.semester,
      academicYear: academicYear ?? this.academicYear,
    );
  }
}