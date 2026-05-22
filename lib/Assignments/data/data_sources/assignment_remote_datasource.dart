import 'package:college_management_saas/Assignments/data/model/assignemnt_model.dart';
import 'package:college_management_saas/Assignments/domain/assignment_entity.dart';
import 'package:dio/dio.dart';

abstract class AssignmentRemoteDataSource {
  Future<AssignmentPageModel> getAssignments(AssignmentListQuery query);
  Future<AssignmentModel> getAssignment(String id);
  Future<AssignmentModel> createAssignment(CreateAssignmentParams params);
  Future<AssignmentModel> updateAssignment(String id, UpdateAssignmentParams params);
  Future<AssignmentSubmissionModel> submitAssignment(
      String assignmentId,
      SubmitAssignmentParams params,
      );
  Future<AssignmentSubmissionModel?> getMySubmission(String assignmentId);
  Future<List<AssignmentSubmissionModel>> getSubmissions(String assignmentId);
  Future<AssignmentSubmissionModel> gradeSubmission(
      String assignmentId,
      String submissionId,
      GradeSubmissionParams params,
      );
}

class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final Dio _dio;

  AssignmentRemoteDataSourceImpl(this._dio);

  @override
  Future<AssignmentPageModel> getAssignments(AssignmentListQuery query) async {
    final response = await _dio.get(
      '/assignments',
      queryParameters: query.toQueryParameters(),
    );

    return AssignmentPageModel.fromJson(_asMap(response.data));
  }

  @override
  Future<AssignmentModel> getAssignment(String id) async {
    final response = await _dio.get('/assignments/$id');
    return AssignmentModel.fromJson(_dataMap(response));
  }

  @override
  Future<AssignmentModel> createAssignment(CreateAssignmentParams params) async {
    final response = await _dio.post('/assignments', data: params.toJson());
    return AssignmentModel.fromJson(_dataMap(response));
  }

  @override
  Future<AssignmentModel> updateAssignment(
      String id,
      UpdateAssignmentParams params,
      ) async {
    final response = await _dio.patch('/assignments/$id', data: params.toJson());
    return AssignmentModel.fromJson(_dataMap(response));
  }

  @override
  Future<AssignmentSubmissionModel> submitAssignment(
      String assignmentId,
      SubmitAssignmentParams params,
      ) async {
    final response = await _dio.post(
      '/assignments/$assignmentId/submit',
      data: params.toJson(),
    );

    return AssignmentSubmissionModel.fromJson(_dataMap(response));
  }

  @override
  Future<AssignmentSubmissionModel?> getMySubmission(String assignmentId) async {
    final response = await _dio.get('/assignments/$assignmentId/my-submission');
    final data = _nullableData(response);
    if (data == null) return null;

    return AssignmentSubmissionModel.fromJson(data);
  }

  @override
  Future<List<AssignmentSubmissionModel>> getSubmissions(String assignmentId) async {
    final response = await _dio.get('/assignments/$assignmentId/submissions');
    final data = _asMap(response.data)['data'];

    final rawList = data is Map ? data['items'] ?? data['submissions'] : data;
    if (rawList is! List) return [];

    return rawList
        .whereType<Map>()
        .map((item) => AssignmentSubmissionModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<AssignmentSubmissionModel> gradeSubmission(
      String assignmentId,
      String submissionId,
      GradeSubmissionParams params,
      ) async {
    final response = await _dio.patch(
      '/assignments/$assignmentId/submissions/$submissionId/grade',
      data: params.toJson(),
    );

    return AssignmentSubmissionModel.fromJson(_dataMap(response));
  }

  Map<String, dynamic> _dataMap(Response<dynamic> response) {
    final map = _asMap(response.data);
    final data = map['data'];

    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return map;
  }

  Map<String, dynamic>? _nullableData(Response<dynamic> response) {
    final map = _asMap(response.data);
    final data = map['data'];

    if (data == null) return null;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {'data': value};
  }
}