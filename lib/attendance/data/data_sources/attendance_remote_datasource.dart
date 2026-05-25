
import 'package:college_management_saas/Attendance/domain/attendance_entity.dart';
import 'package:college_management_saas/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import '../model/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceDayModel> getAttendance(AttendanceQuery query);
  Future<AttendanceDayModel> saveAttendance(
      String date,
      List<AttendanceStudent> students,
      );
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio _dio;

  AttendanceRemoteDataSourceImpl(this._dio);

  @override
  Future<AttendanceDayModel> getAttendance(AttendanceQuery query) async {
    final response = await _dio.get(
      ApiConstants.attendance,
      queryParameters: query.toQueryParameters(),
    );

    return AttendanceDayModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AttendanceDayModel> saveAttendance(
      String date,
      List<AttendanceStudent> students,
      ) async {
    final response = await _dio.post(
      ApiConstants.attendance,
      data: {
        'date': date,
        'records': students
            .map((student) => {
          'student_id': student.id,
          'status': student.status.apiValue,
        })
            .toList(),
      },
    );

    return AttendanceDayModel.fromJson(response.data as Map<String, dynamic>);
  }
}