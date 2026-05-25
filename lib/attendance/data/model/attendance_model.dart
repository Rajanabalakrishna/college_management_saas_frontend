import 'package:college_management_saas/Attendance/domain/attendance_entity.dart';

class AttendanceStudentModel extends AttendanceStudent {
  const AttendanceStudentModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.rollNo,
    super.className,
    super.sec,
    super.branch,
    super.year,
    super.attendanceId,
    required super.status,
    super.markedAt,
  });

  factory AttendanceStudentModel.fromJson(Map<String, dynamic> json) {
    return AttendanceStudentModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      rollNo: json['roll_no'] as String?,
      className: (json['class'] ?? json['class_name']) as String?,
      sec: json['sec'] as String?,
      branch: json['branch'] as String?,
      year: _toInt(json['year']),
      attendanceId: json['attendance_id'] as String?,
      status: attendanceStatusFromApi(json['attendance_status'] as String?),
      markedAt: json['marked_at'] == null
          ? null
          : DateTime.tryParse(json['marked_at'].toString()),
    );
  }
}

class AttendanceDayModel extends AttendanceDay {
  const AttendanceDayModel({
    required super.date,
    required super.today,
    required super.editable,
    required super.total,
    required super.presentCount,
    required super.absentCount,
    required super.students,
  });

  factory AttendanceDayModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final rawStudents = data['students'] as List? ?? [];

    return AttendanceDayModel(
      date: data['date']?.toString() ?? '',
      today: data['today']?.toString() ?? '',
      editable: data['editable'] == true,
      total: _toInt(data['total']) ?? 0,
      presentCount: _toInt(data['present_count']) ?? 0,
      absentCount: _toInt(data['absent_count']) ?? 0,
      students: rawStudents
          .map((e) => AttendanceStudentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}