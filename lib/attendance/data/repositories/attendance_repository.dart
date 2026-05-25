import 'package:college_management_saas/Attendance/data/data_sources/attendance_remote_datasource.dart';
import 'package:college_management_saas/Attendance/domain/attendance_entity.dart';
import 'package:college_management_saas/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceDay>> getAttendance(AttendanceQuery query);
  Future<Either<Failure, AttendanceDay>> saveAttendance(
      String date,
      List<AttendanceStudent> students,
      );
}

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource _remote;

  AttendanceRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, AttendanceDay>> getAttendance(AttendanceQuery query) async {
    try {
      return Right(await _remote.getAttendance(query));
    } on DioException catch (e) {
      return Left(_failureFromDio(e, 'Unable to load attendance'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceDay>> saveAttendance(
      String date,
      List<AttendanceStudent> students,
      ) async {
    try {
      return Right(await _remote.saveAttendance(date, students));
    } on DioException catch (e) {
      return Left(_failureFromDio(e, 'Unable to save attendance'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _failureFromDio(DioException e, String fallback) {
    final data = e.response?.data;
    final message = data is Map
        ? data['error']?.toString() ?? data['message']?.toString()
        : null;

    if (e.response?.statusCode == 401) {
      return UnauthorizedFailure(message ?? 'Session expired');
    }

    return ServerFailure(message ?? fallback);
  }
}