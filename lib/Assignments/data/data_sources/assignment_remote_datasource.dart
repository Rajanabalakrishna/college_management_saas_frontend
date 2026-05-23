import 'package:college_management_saas/Assignments/data/model/assignemnt_model.dart';
import 'package:college_management_saas/Assignments/domain/assignment_entity.dart';
import 'package:dio/dio.dart';

abstract class AssignmentRemoteDataSource {
  Future<AssignmentPageModel> getAssignments(AssignmentListQuery query);
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

    return AssignmentPageModel.fromJson(response.data as Map<String, dynamic>);
  }
}