import 'package:college_management_saas/Results/data/models/result_model.dart';
import 'package:college_management_saas/Results/domain/result_entity.dart';
import 'package:college_management_saas/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

abstract class ResultRemoteDataSource {
  Future<ResultPageModel> getResults(ResultQuery query);
}

class ResultRemoteDataSourceImpl implements ResultRemoteDataSource {
  final Dio _dio;

  ResultRemoteDataSourceImpl(this._dio);

  @override
  Future<ResultPageModel> getResults(ResultQuery query) async {
    final response = await _dio.get(
      ApiConstants.results,
      queryParameters: query.toQueryParameters(),
    );

    return ResultPageModel.fromJson(response.data as Map<String, dynamic>);
  }
}