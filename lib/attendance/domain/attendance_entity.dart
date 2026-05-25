enum AttendanceStatus { present, absent }

AttendanceStatus attendanceStatusFromApi(String? value) {
  switch (value?.toUpperCase()) {
    case 'PRESENT':
      return AttendanceStatus.present;
    default:
      return AttendanceStatus.absent;
  }
}

extension AttendanceStatusX on AttendanceStatus {
  String get apiValue {
    switch (this) {
      case AttendanceStatus.present:
        return 'PRESENT';
      case AttendanceStatus.absent:
        return 'ABSENT';
    }
  }

  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
    }
  }
}

class AttendanceStudent {
  final String id;
  final String email;
  final String fullName;
  final String? rollNo;
  final String? className;
  final String? sec;
  final String? branch;
  final int? year;
  final String? attendanceId;
  final AttendanceStatus status;
  final DateTime? markedAt;

  const AttendanceStudent({
    required this.id,
    required this.email,
    required this.fullName,
    this.rollNo,
    this.className,
    this.sec,
    this.branch,
    this.year,
    this.attendanceId,
    required this.status,
    this.markedAt,
  });

  AttendanceStudent copyWith({
    AttendanceStatus? status,
    String? attendanceId,
    DateTime? markedAt,
  }) {
    return AttendanceStudent(
      id: id,
      email: email,
      fullName: fullName,
      rollNo: rollNo,
      className: className,
      sec: sec,
      branch: branch,
      year: year,
      attendanceId: attendanceId ?? this.attendanceId,
      status: status ?? this.status,
      markedAt: markedAt ?? this.markedAt,
    );
  }
}

class AttendanceDay {
  final String date;
  final String today;
  final bool editable;
  final int total;
  final int presentCount;
  final int absentCount;
  final List<AttendanceStudent> students;

  const AttendanceDay({
    required this.date,
    required this.today,
    required this.editable,
    required this.total,
    required this.presentCount,
    required this.absentCount,
    required this.students,
  });

  AttendanceDay copyWith({
    String? date,
    String? today,
    bool? editable,
    int? total,
    int? presentCount,
    int? absentCount,
    List<AttendanceStudent>? students,
  }) {
    return AttendanceDay(
      date: date ?? this.date,
      today: today ?? this.today,
      editable: editable ?? this.editable,
      total: total ?? this.total,
      presentCount: presentCount ?? this.presentCount,
      absentCount: absentCount ?? this.absentCount,
      students: students ?? this.students,
    );
  }
}

class AttendanceQuery {
  final String date;
  final String? className;
  final String? sec;
  final String? branch;
  final int? year;

  const AttendanceQuery({
    required this.date,
    this.className,
    this.sec,
    this.branch,
    this.year,
  });

  Map<String, dynamic> toQueryParameters() {
    final data = {
      'date': date,
      'class_name': className,
      'sec': sec,
      'branch': branch,
      'year': year,
    };

    data.removeWhere((_, value) => value == null || value == '');
    return data;
  }

  AttendanceQuery copyWith({
    String? date,
    String? className,
    String? sec,
    String? branch,
    int? year,
    bool clearFilters = false,
  }) {
    return AttendanceQuery(
      date: date ?? this.date,
      className: clearFilters ? null : className ?? this.className,
      sec: clearFilters ? null : sec ?? this.sec,
      branch: clearFilters ? null : branch ?? this.branch,
      year: clearFilters ? null : year ?? this.year,
    );
  }
}